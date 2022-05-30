<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Project;
use App\Gig;
use App\Campaign;
use App\ProjectApps as JA;
use App\Employer;
use App\JobProof;
use App\User;
use App\Question as Qs;
use App\QAnswer as QA;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class ProjectController extends Controller
{
    public function list(Request $request){
        $projects = Project::get();
        foreach($projects as $project){
            $user = Employer::find($project->user);
            $project->image = asset('assets/employer/profile_images/'.$user->profile_photo);
            $project->brand=$user->cname;
        }
        return response()->json(['response'=>['code'=>'SUCCESS','projects'=>$projects,'count'=>$projects->count()]], 200);
    }
    
    public function details(Request $request){
        $this->validate($request,[
            'id' => 'required',
        ]);
        $project = Project::find($request->id);
        if($project==NULL){
            return response()->json(['response'=>['code'=>'PROJECT NOT FOUND']], 401);
        }
        else{
            $emp = Employer::find($project->user);
            $image = asset('assets/employer/profile_images/'.$emp->profile_photo);
            $qs = Qs::where('pid',$request->id)->get();
            return response()->json(['response'=>['code'=>'SUCCESS','project'=>$project,'company'=>$emp,'questions'=>$qs,'image' => $image]], 200);
        }
    }
    public function apply(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'answer'=>'required',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $job = Project::find($request->id);
            if($job==NULL){
                return response()->json(['response'=>['code'=>'PROJECT NOT FOUND']], 401);
            }
            elseif(JA::where(['uid' => $request->uid,'jid' => $request->id])->exists()){
                return response()->json(['response'=>['code'=>'USER HAS ALREADY APPLIED FOR THIS PROJECT']], 401);
            }
            else{
                $job = new JA;
                $job->uid = $request->uid;
                $job->jid = $request->id;
                $job->status = 0;
                $qs = Qs::select('id')->where('pid',$request->id)->pluck('id');
                $i = 0;
                $ans = $request->answer;
                foreach($ans as $an){
                    $qa = new QA;
                    $qa->uid = $request->uid;
                    $qa->qid = $qs[$i];
                    $qa->answer = $an;
                    $qa->save();
                    $i = $i+1;
                }
                $job->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function proofs(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $job = Project::find($request->id);
            if($job==NULL){
                return response()->json(['response'=>['code'=>'PROJECT NOT FOUND']], 401);
            }
            elseif(JobProof::where(['uid' => $user->id,'jid' => $job->id])->exists()){
                return response()->json(['response'=>['code'=>'PROOF IS ALREADY SUBMITTED']], 401);
            }
            else{
                $jp = new JobProof;
                $jp->uid = $user->id;
                $jp->jid = $job->id;
                $jp->proof = "Proof:";
                $proofs = explode(',',$job->proofs);
                if(in_array('Link',$proofs)){
                    $this->validate($request,[
                        'link' => 'required',
                    ]);
                    $jp->proof = $jp->proof." Link: ".$request->link;
                }
                if(in_array('File',$proofs)){
                    $this->validate($request,[
                        'file' => 'required',
                    ]);
                    if($request->hasFile('file')){
                        $path = "assets/user/images/jobproof_files/";
                        $name = $_FILES['file']['name'];
                        $tmp = $_FILES['file']['tmp_name'];
                        $name = "Proof_".$user->id."_".$name;
                        if(move_uploaded_file($tmp,$path.$name)){
                            $asset = asset('assets/user/images/jobproof_files/'.$name);
                            $jp->proof = $jp->proof." <br/> File: <a href=\"".$asset."\">Click here to view the file</a>";
                        }
                    }
                }
                if(in_array('Image',$proofs)){
                    if($request->hasFile('image')){
                        $path = "assets/user/images/jobproof_images/";
                        $name = $_FILES['image']['name'];
                        $tmp = $_FILES['image']['tmp_name'];
                        $name = "Proof_".$user->id."_".$name;
                        if(move_uploaded_file($tmp,$path.$name)){
                            $asset = asset('assets/user/images/jobproof_images/'.$name);
                            $jp->proof = $jp->proof." <br/> Image: <a href=\"".$asset."\">Click here to view the image</a>";
                        }
                    }
                }
                $jp->save();
                $ja = JA::where(['jid'=> $job->id, 'uid' => $user->id])->first();
                $ja->status = 4;
                $ja->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function mobile(){
        $projects = Project::where('mobile',1)->get();
        foreach($projects as $project){
            $user = Employer::find($project->user);
            $project->image = asset('assets/employer/profile_images/'.$user->profile_photo);
            $project->brand=$user->cname;
        }
        $gigs = Gig::where('mobile',1)->get();
        $campaigns = Campaign::where('mobile',1)->get();
        return response()->json(['response'=>['code'=>'SUCCESS','projects'=>$projects,'gigs'=>$gigs,'campaigns'=>$campaigns]], 200);
    }
}
