<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Gig;
use App\GigCategory as CC;
use App\CompletedGig as CJ;
use App\GigApp as GA;
use App\User;
use App\Task;
use App\Employer;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class GigController extends Controller
{
    public function list(){
        $gigs = Gig::get();
        return response()->json(['response'=>['code'=>'SUCCESS','gigs'=>$gigs,'count'=>$gigs->count()]], 200);
    }
    public function details(Request $request){
        $this->validate($request,[
            'id' => 'required',
        ]);
        $gig = Gig::find($request->id);
        if($gig==NULL){
            return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
        }
        else{
            if($gig->user_id=="Admin"){
                $user = "Admin";
                $image = asset('assets/admin/img/gig-brand-logo/'.$gig->logo);
            }
            else{
                $user = Employer::find($gig->user_id);
                $image = asset('assets/employer/profile_images/'.$user->profile_photo);
            }
            $tasks = Task::where('cid',$request->id)->get();
            return response()->json(['response'=>['code'=>'SUCCESS','gig'=>$gig,'company'=>$user,'tasks'=>$tasks,'image' => $image]], 200);
        }
    }
    public function apply(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            elseif(GA::where(['uid' => $request->uid,'cid' => $request->id])->exists()){
                return response()->json(['response'=>['code'=>'USER HAS ALREADY APPLIED FOR THE GIG']], 401);
            }
            else{
                $job = new GA;
                $job->uid = $request->uid;
                $job->cid = $request->id;
                $job->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function prooffb(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'username' => 'required',
            'link' => 'required',
            'ss' => 'required|image',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Username: ".$request->username.", Post Link: ".$request->link.", Type: Facebook";
                if($request->hasFile('ss')){
                    $name = $_FILES['ss']['name'];
                    $tmp = $_FILES['ss']['tmp_name'];
                    $path = "assets/user/images/proof_file/";
                    $name = "Proof_FB_".$request->id."_user_".$request->username."_".$name;
                    if(move_uploaded_file($tmp,$path.$name)){
                        $cj->proof_file = $name;
                    }
                }
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' => $request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function proofwa(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'phone' => 'required',
            'ss' => 'required|image',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Phone: ".$request->phone.", Type: Whatsapp";
                if($request->hasFile('ss')){
                    $name = $_FILES['ss']['name'];
                    $tmp = $_FILES['ss']['tmp_name'];
                    $path = "assets/user/images/proof_file/";
                    $name = "Proof_WA_".$request->id."_user_".$request->phone."_".$name;
                    if(move_uploaded_file($tmp,$path.$name)){
                        $cj->proof_file = $name;
                    }
                }
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' =>$request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function proofinsta(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'username' => 'required',
            'link' => 'required',
            'ss' => 'required|image',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Username: ".$request->username.", Post Link: ".$request->link.", Type: Instagram";
                if($request->hasFile('ss')){
                    $name = $_FILES['ss']['name'];
                    $tmp = $_FILES['ss']['tmp_name'];
                    $path = "assets/user/images/proof_file/";
                    $name = "Proof_Insta_".$request->id."_user_".$request->username."_".$name;
                    if(move_uploaded_file($tmp,$path.$name)){
                        $cj->proof_file = $name;
                    }
                }
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' => $request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function proofyt(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'username' => 'required',
            'ss' => 'required|image',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Username: ".$request->username.", Type: Youtube";
                if($request->hasFile('ss')){
                    $name = $_FILES['ss']['name'];
                    $tmp = $_FILES['ss']['tmp_name'];
                    $path = "assets/user/images/proof_file/";
                    $name = "Proof_Youtube_".$request->id."_user_".$request->username."_".$name;
                    if(move_uploaded_file($tmp,$path.$name)){
                        $cj->proof_file = $name;
                    }
                }
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' => $request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function proofinstap(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'username' => 'required',
            'link' => 'required',
            'ss' => 'required|image',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Username: ".$request->username.", Post Link: ".$request->link.", Screenshot: ".$request->ss.", Type: Instagram Post";
                if($request->hasFile('ss')){
                    $name = $_FILES['ss']['name'];
                    $tmp = $_FILES['ss']['tmp_name'];
                    $path = "assets/user/images/proof_file/";
                    $name = "Proof_Insta_".$request->id."_user_".$request->username."_".$name;
                    if(move_uploaded_file($tmp,$path.$name)){
                        $cj->proof_file = $name;
                    }
                    else{
                        $request->session()->flash('error', "Cannot upload screenshot. Try again.");
                        return redirect()->back();
                    }
                }
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' => $request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }

    public function proofos(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'email' => 'required',
            'ss' => 'required|image',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Email: ".$request->email.", Screenshot: ".$request->ss.", Type: Online Survey";
                if($request->hasFile('ss')){
                    $name = $_FILES['ss']['name'];
                    $tmp = $_FILES['ss']['tmp_name'];
                    $path = "assets/user/images/proof_file/";
                    $name = "Proof_OS_".$request->id."_".$name;
                    if(move_uploaded_file($tmp,$path.$name)){
                        $cj->proof_file = $name;
                    }
                    else{
                        $request->session()->flash('error', "Cannot upload screenshot. Try again.");
                        return redirect()->back();
                    }
                }
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' => $request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }
    public function proofar(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'cred' => 'required',
            'ss' => 'required|image',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Credentials: ".$request->cred." , Type: Download App";
                if($request->hasFile('ss')){
                    $name = $_FILES['ss']['name'];
                    $tmp = $_FILES['ss']['tmp_name'];
                    $path = "assets/user/images/proof_file/";
                    $name = "Proof_App_".$request->id."_user_".$request->username."_".$name;
                    if(move_uploaded_file($tmp,$path.$name)){
                        $cj->proof_file = $name;
                    }
                }
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' => $request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }
    public function proofls(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
            'cred' => 'required',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gig = Gig::find($request->id);
            if($gig==NULL){
                return response()->json(['response'=>['code'=>'GIG NOT FOUND']], 401);
            }
            else{
                $cj = new CJ;
                $text = "Credentials: ".$request->cred.", Type: Social Media";
                $cj->proof_text = $text;
                $cj->job_id = $request->id;
                $cj->user_id = $request->uid;
                $cj->status==0;
                $cj->save();
                $ga = GA::where(['uid' => $request->uid,'cid' => $request->id])->first();
                $ga->status = 3;
                $ga->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
    }
    public function proofs(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'uid' => 'required',
        ]);
        $apps = CJ::where(['job_id'=>$request->id,'user_id'=>$request->uid])->get();
        return response()->json(['response'=>['code'=>'SUCCESS','proofs'=>$apps]], 200);
    }
}
