<?php

namespace App\Http\Controllers\API\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Skill;
use App\Education;
use App\Experiences;
use App\UserProject;
use App\Select;
use App\Reject;
use App\Shortlisted;
use App\Project;
use App\ProjectApps;
use App\CompletedGig;
use App\GigApp as GA;
use Carbon\Carbon;
use App\Withdraw;
use App\WithdrawRequest;
use App\Transition;
use App\Gig;
use App\Campaign;
use App\Employer;
use App\CampaignApp;

class DetailController extends Controller
{
    public function details(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $user = User::find($request->id);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            return response()->json(['response'=>['code'=>'SUCCESS','user' => $user]], 200);
        }
    }
    public function skills(Request $request){
        $this->validate($request,[
            'uid' => 'required'
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $skills = Skill::where('uid',$user->id)->get();
            return response()->json(['response'=>['code'=>'SUCCESS','user'=>$user,'skills'=>$skills,'count'=>$skills->count()]], 200);
        }
    }
    public function exp(Request $request){
        $this->validate($request,[
            'uid' => 'required'
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $exps = Experiences::where('uid',$user->id)->get();
            return response()->json(['response'=>['code'=>'SUCCESS','user'=>$user,'exps'=>$exps,'count'=>$exps->count()]], 200);
        }
    }
    public function edu(Request $request){
        $this->validate($request,[
            'uid' => 'required'
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $edus = Education::where('uid',$user->id)->get();
            return response()->json(['response'=>['code'=>'SUCCESS','user'=>$user,'edus'=>$edus,'count'=>$edus->count()]], 200);
        }
    }
    public function projects(Request $request){
        $this->validate($request,[
            'uid' => 'required'
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $projects = UserProject::where('uid',$user->id)->get();
            return response()->json(['response'=>['code'=>'SUCCESS','user'=>$user,'projects'=>$projects,'count'=>$projects->count()]], 200);
        }
    }

    
    public function hobbyUpdate(Request $request){
        $this->validate($request,[
            'uid'=>'required',
            'hobby' => 'required'
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $user->hobbies = $request->hobby;
            $user->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function achUpdate(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'ach' => 'required'
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $user->achievements = $request->ach;
            $user->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function socialUpdate(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'fb' => 'nullable',
            'twitter' => 'nullable',
            'linkedin' => 'nullable',
            'github' => 'nullable',
            'insta' => 'nullable',
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $user->fb = $request->fb;
            $user->twitter = $request->twitter;
            $user->linkedin = $request->linkedin;
            $user->github = $request->github;
            $user->insta = $request->insta;
            $user->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }

    public function eduUpdate(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'type' => "required",
            'name' => "required",
            'course' => "required",
            'start' => "required",
            'end' => "required",
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $edu = new Education;
            $edu->type = $request->type;
            $edu->name = $request->name;
            $edu->course = $request->course;
            $edu->start = $request->start;
            $edu->end = $request->end;
            $edu->uid = $request->uid;
            $edu->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function expUpdate(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'company' => "required",
            'designation' => "required",
            'des' => "required",
            'start' => "required",
            'end' => "required",
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $exp = new Experiences;
            $exp->company = $request->company;
            $exp->designation = $request->designation;
            $exp->des = $request->des;
            $exp->start = $request->start;
            $exp->end = $request->end;
            $exp->uid = $request->uid;
            $exp->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function projectsUpdate(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'title' => "required",
            'projdes' => "required",
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $proj = new UserProject;
            $proj->title = $request->title;
            $proj->des = $request->projdes;
            $proj->uid = $request->uid;
            $proj->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function skillsUpdate(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'name' => "required",
            'rating' => "required",
        ]);
        $user = User::find($request->uid);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER DOES NOT EXIST']], 401);
        }
        else{
            $skill = new Skill;
            $skill->name = $request->name;
            $skill->rating = $request->rating;
            $skill->uid = $request->uid;
            $skill->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }

    public function eduDelete(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $edu = Education::find($request->id);
        if($edu==NULL){
            return response()->json(['response'=>['code'=>'THIS ENTRY DOES NOT EXIST']], 401);
        }
        else{
            $edu->delete();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function expDelete(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $exp = Experiences::find($request->id);
        if($exp==NULL){
            return response()->json(['response'=>['code'=>'THIS ENTRY DOES NOT EXIST']], 401);
        }
        else{
            $exp->delete();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function projectsDelete(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $project = UserProject::find($request->id);
        if($project==NULL){
            return response()->json(['response'=>['code'=>'THIS ENTRY DOES NOT EXIST']], 401);
        }
        else{
            $project->delete();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }
    public function skillsDelete(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $skill = Skill::find($request->id);
        if($skill==NULL){
            return response()->json(['response'=>['code'=>'THIS ENTRY DOES NOT EXIST']], 401);
        }
        else{
            $skill->delete();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }

    
    public function jprojects(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $user = User::find($request->id);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $projects = ProjectApps::where('uid', $request->id)->get();
            $aprojs = array();
            foreach($projects as $project){
                $uproj = Project::find($project->jid);
                $euser=Employer::find($uproj->user);
           $uproj->image=asset('assets/employer/profile_images/'.$euser->profile_photo);
           $uproj->brand=$euser->cname;
                $aprojs[] = $uproj;
            }
            return response()->json(['response'=>['code'=>'SUCCESS','projects' => $projects,'projectsinfo'=>$aprojs]], 200);
        }
    }
    public function gigs(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $user = User::find($request->id);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $gigs = GA::where('uid', $request->id)->get();
            $agigs = array();
            foreach($gigs as $gig){
                $ugig = Gig::find($gig->cid);
                $agigs[] = $ugig;
            }
            return response()->json(['response'=>['code'=>'SUCCESS','gigs' => $gigs,'gigsinfo'=>$agigs]], 200);
        }
    }
    public function campaigns(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $user = User::find($request->id);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $campaigns = CampaignApp::where('uid', $request->id)->get();
            $acampaigns = array();
            foreach($campaigns as $campaign){
                $ucamp = Campaign::find($campaign->cid);
                $acampaigns[] = $ucamp;
            }
            return response()->json(['response'=>['code'=>'SUCCESS','campaigns' => $campaigns,'campaigninfo'=>$acampaigns]], 200);
        }
    }
    public function profileUpdate(Request $request){

        //validation
        $this->validate($request, [
            'id' => 'required',
            'name' => 'required',
            'state' => 'required',
            'city' => 'required',
            'address' => 'required',
            'phone' => 'required',
            'zip_code' => 'required',
        ]);

        $user = User::find($request->id);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $user->name = $request->name;
            $user->state = $request->state;
            $user->city = $request->city;
            $user->address = $request->address;

            $user->phone = $request->phone;
            $user->zip_code = $request->zip_code;


            $user->save();
            return response()->json(['response'=>['code'=>'SUCCESS']], 200);
        }
    }

    public function passUpdate(Request $request)
    {
        //validation
        $this->validate($request, [
            'id' => 'required',
            'current_password' => 'required',
            'password' => 'required'
        ]);
        $user = User::find($request->id);
        if($user==NULL){
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
        else{
            $UserPassword = $user->password;
            if (password_verify($request->current_password, $UserPassword)) {
                $user->password = Hash::make($request->password);
                $user->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            } 
            else {
                return response()->json(['response'=>['code'=>'CURRENT PASSWORD IS INCORRECT']], 401);
            }
        }
    }

    // Withdraws

    public function withdrawMethod(){
        $withdrawMethods = Withdraw::get();
        return response()->json(['response'=>['code'=>'SUCCESS','method'=>$withdrawMethods,'count'=>$withdrawMethods->count()]], 200);
    }
    public function withdraw(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'amount' => 'required',
            'method_id' => 'required',
            'details' => 'required',
        ]);
        $user = User::find($request->uid);
        if($user!=NULL){
            if($user->balance<$request->amount){
                return response()->json(['response'=>['code'=>'USER BALANCE IS NOT SUFFICIENT']], 401);
            }
            else{
                $user_balance = $user->balance;
                $user_balance -=$request->amount;
                User::where('id', $user->id)->update(['balance' => $user_balance]);

                $withdrawRequest = new WithdrawRequest();
                $withdrawRequest->withdraw_method_id = $request->method_id;
                $withdrawRequest->user_id = $request->uid;
                $withdrawRequest->payment_details = $request->details;
                $withdrawRequest->payable_amount = $request->amount;

                $withdrawRequest->save();

                $tr = new Transition;
                $tr->uid = $request->uid;
                $tr->reason = "Withdrawal";
                $tr->transition = "-".$request->amount;
                $tr->save();
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
        else{
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
    }
    public function transactions(Request $request){
        $this->validate($request,[
            'uid' => 'required',
        ]);
        $user = User::find($request->uid);
        if($user!=NULL){
            $trs = Transition::where('uid',$request->uid)->get();
            return response()->json(['response'=>['code'=>'SUCCESS','transactions'=>$trs]], 200);
        }
        else{
            return response()->json(['response'=>['code'=>'USER NOT FOUND']], 401);
        }
    }

    // Profile Photo update API
    public function profileImage(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'profile_photo' => 'required',
        ]);
        
        $user = User::find($request->id);
        $path = 'assets/user/images/user_profile/';
        $img = $request->profile_photo;
        $img = str_replace('data:image/png;base64,', '', $img);
        $img = str_replace(' ', '+', $img);
        $data = base64_decode($img);
        $name = uniqid() . '.png';
        $file = $path . $name;
        $success = file_put_contents($file, $data);
        $user->profile_photo = $name;
        $user->save();
        
        return $success?response()->json(['response'=>['code'=>'SUCCESS']], 200):response()->json(['response'=>['code'=>'UNSUCCESS']], 401);
    }

    public function allTransactions(Request $request){
        $user = User::find($request->id);
        $refs = User::where('ref_by',$request->id)->get();
        // For referrals
        $radds = Transition::where('uid',$request->id)->where('reason','LIKE','%Referral Bonus%')->get();
        if($radds->count()==0){
            $ra = 0;
        }
        else{
            $ra = 0;
            foreach($radds as $radd){
                $ra = $ra + $radd->addm;
            }
        }
        // For gigs
        $gadds = Transition::where('uid',$request->id)->where('reason','LIKE','%Gig%')->get();
        if($gadds->count()==0){
            $ga = 0;
        }
        else{
            $ga = 0;
            foreach($gadds as $gadd){
                $ga = $ga + $gadd->addm;
            }
        }
        // For projects
        $padds = Transition::where('uid',$request->id)->where('reason','LIKE','%Project%')->get();
        if($padds->count()==0){
            $pa = 0;
        }
        else{
            $pa = 0;
            foreach($padds as $padd){
                $pa = $pa + $padd->addm;
            }
        }
        // For campaigns
        $cadds = Transition::where('uid',$request->id)->where('reason','LIKE','%Campaign%')->get();
        if($cadds->count()==0){
            $ca = 0;
        }
        else{
            $ca = 0;
            foreach($cadds as $cadd){
                $ca = $ca + $cadd->addm;
            }
        }
        return response()->json(['response'=>['code'=>'SUCCESS','referralEarnings'=>$ra,'gigEarnings'=>$ga,'projectEarnings'=>$pa,'campaignEarnings'=>$ca,'referred'=>$refs->count(),'balance'=>$user->balance]], 200);
    }
    public function storeRef(Request $request){
        $this->validate($request,[
            'uid' => 'required',
            'ref' => 'required'
        ]);
        $user = User::find($request->uid);
        if($user->ref_by == NULL){
            $refu = User::where('ref_code',$request->ref)->first();
            if($refu == NULL){
                return response()->json(['response'=>['code'=>'ERROR','message'=>'The referral code does not exist']], 401);
            }
            else{
                $user->ref_by = $refu->id;
                return response()->json(['response'=>['code'=>'SUCCESS']], 200);
            }
        }
        else{
            return response()->json(['response'=>['code'=>'ERROR','message'=>'The user is already referred by someone else']], 401);
        }
    }
}
