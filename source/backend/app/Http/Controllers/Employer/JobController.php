<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Employer;
use App\Pending;
use App\ProjectApps as JA;
use App\Project;
use App\Shortlisted;
use App\Select;
use App\Reject;
use App\Certificate;
use App\Mail\certificate_mail;
use Illuminate\Support\Facades\Mail;
use App\JobProof;
use App\User;
use App\Mail\GlobalMail;
use App\PendingQuestion as PQ;
use App\Question as Qs;
use App\Transition;
use App\Exports\ProjectProofs;
use App\Exports\EmPrApps;
use App\Exports\EmPrSls;
use App\Exports\EmPrSl;
use Excel;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class JobController extends Controller
{
    public function manage(){
        $em = Employer::find(Auth::guard('employer')->id());
        $jobs = Project::where('user',$em->id)->orderBy('updated_at','desc')->paginate(15);
        $pjobs = Pending::where('user',$em->id)->orderBy('created_at','desc')->paginate(15);
        return view('employer.projects.manage')->with([
            'employer' => $em,
            'jobs' => $jobs,
            'pjobs' => $pjobs,
        ]);
    }
    public function postr(){
        $employer = Employer::find(Auth::guard('employer')->id());
        $cats = [
            "SALES & BUSINESS DEVELOPMENT",
            "PRODUCTION",
            "MAINTENANCE",
            "ACCOUNTING AND FINANCE",
            "ADMIN & HUMAN RESAURCES (HR) MANAGEMENT",
            "PROCUREMENT & PLANNING",
            "TESTING & QUALITY",
            "RESEARCH & DEVELOPMENT (R & D)",
            "DESIGN",
            "MARKETING",
            "TRAINING & DEVELOPMENT",
            "PURCHASING",
            "SUPPLY CHAIN MANAGEMENT",
            "INVENTORY & STORE",
            "IT & ITES",
            "ENVIRONMENTAL HEALTH AND SAFETY",
            "CORPORATE SUPPORT",
            "ENGINEERING",
            "ELECTRICAL",
            "MECHANICAL",
            "FACILITY MANAGEMENT",
            "CUSTOMER SERVICE SUPPORT",
            "CONSULTANT",
            "EXPERT",
            "CONTRACTOR",
            "OTHER",
        ];
        return view('employer.projects.post')->with([
            'employer' => $employer,
            'cats' => $cats,
        ]);
    }
    public function post(Request $request){
        $this->validate($request,[
            'title' => 'required|min:10',
            'des' => 'required',
            'cat' => 'required',
            'start' => 'required',
            'end' => 'required',
            'duration' => 'required',
        ]);
        $em = Employer::find(Auth::guard('employer')->id());
        $pending = new Pending;
        $pending->title = $request->title;
        $pending->des = $request->des;
        $pending->cat = $request->cat;
        $pending->start = $request->start;
        $pending->end = $request->end;
        $pending->duration = $request->duration;
        $pending->save();
        return view('employer.projects.benefits')->with([
            'pending' => $pending->id,
            'employer' =>$em,
        ]);
    }
    public function postbene(Request $request){
        $this->validate($request,[
            'stipend' => 'required',
            'benefits' => 'required',
            'place' => 'required',
            'count' => 'required',
            'skills' => 'required',
            'pending' => 'required',
            'proofs' => 'required',
            'question' => 'required',
        ]);
        $em = Employer::find(Auth::guard('employer')->id());
        $pending = Pending::find($request->pending);
        $pending->stipend = $request->stipend;
        $pending->benefits = $request->benefits;
        $pending->place = $request->place;
        $pending->count = $request->count;
        $pending->skills = $request->skills;
        $pending->user = $em->id;
        $proofs = "";
        foreach($request->proofs as $proof){
            $proofs = $proof.",".$proofs;
        }
        $pending->proofs = $proofs;
        $pending->save();
        $questions = $request->question;
        foreach($questions as $question){
            $q = new PQ;
            $q->pid = $pending->id;
            $q->question = $question;
            $q->save();
        }

        // Mail
        $sub = "Your Project is Created";
        $message="<p>Dear {$em->name},</p><p>Your Project, {$pending->title}, has been created successfully, and is waiting for the approval from the admin.</p>";
        $data = array('sub'=>$sub,'message'=>$message);
        Mail::to($em->email)->send(new GlobalMail($data));

        return redirect()->route('employer.job.confirmation');
    }
    public function confirmation(){
        $em = Employer::find(Auth::guard('employer')->id());
        return view('employer.projects.confirmation')->with([
            'employer' => $em
        ]);
    }
    public function editr($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            $cats = [
                "SALES & BUSINESS DEVELOPMENT",
                "PRODUCTION",
                "MAINTENANCE",
                "ACCOUNTING AND FINANCE",
                "ADMIN & HUMAN RESAURCES (HR) MANAGEMENT",
                "PROCUREMENT & PLANNING",
                "TESTING & QUALITY",
                "RESEARCH & DEVELOPMENT (R & D)",
                "DESIGN",
                "MARKETING",
                "TRAINING & DEVELOPMENT",
                "PURCHASING",
                "SUPPLY CHAIN MANAGEMENT",
                "INVENTORY & STORE",
                "IT & ITES",
                "ENVIRONMENTAL HEALTH AND SAFETY",
                "CORPORATE SUPPORT",
                "ENGINEERING",
                "ELECTRICAL",
                "MECHANICAL",
                "FACILITY MANAGEMENT",
                "CUSTOMER SERVICE SUPPORT",
                "CONSULTANT",
                "EXPERT",
                "CONTRACTOR",
                "OTHER",
            ];
            return view('employer.projects.edit')->with([
                'employer'=>$em,
                'job' => $job,
                'cats' => $cats,
            ]);
        }
        else{
            Session()->flash('warning','You cannot edit this project');
            return redirect()->back();
        }
    }
    public function edit($id,Request $request){
        $this->validate($request,[
            'title' => 'required|min:10',
            'des' => 'required',
            'cat' => 'required',
            'start' => 'required',
            'end' => 'required',
            'duration' => 'required',
            'stipend' => 'required',
            'benefits' => 'required',
            'place' => 'required',
            'count' => 'required',
            'skills' => 'required',
        ]);
        $em = Employer::find(Auth::guard('employer')->id());
        $pending = Project::find($id);
        $pending->title = $request->title;
        $pending->des = $request->des;
        $pending->cat = $request->cat;
        $pending->start = $request->start;
        $pending->end = $request->end;
        $pending->duration = $request->duration;
        $pending->stipend = $request->stipend;
        $pending->benefits = $request->benefits;
        $pending->place = $request->place;
        $pending->count = $request->count;
        $pending->skills = $request->skills;
        $pending->save();

        // Mail
        $sub = "Your Project is Modified";
        $message="<p>Dear {$em->name},</p><p>Your Project, {$pending->title}, has been modified successfully. If you didn not edit it, kindly change your password immediately.</p>";
        $data = array('sub'=>$sub,'message'=>$message);
        Mail::to($em->email)->send(new GlobalMail($data));

        Session()->flash('success','Details Modified');
        return redirect()->back();
    }
    public function delete($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            $job->delete();

            // Mail
            $sub = "Your Project is deleted";
            $message="<p>Dear {$em->name},</p><p>Your Project, {$job->title}, has been deleted successfully. If you didn not delete it, kindly change your password immediately.</p>";
            $data = array('sub'=>$sub,'message'=>$message);
            Mail::to($em->email)->send(new GlobalMail($data));

            Session()->flash('success','Project is deleted');
            return redirect()->back();
        }
        else{
            Session()->flash('warning','You cannot delete this project');
            return redirect()->back();
        }
    }
    public function applications($id){
        if(!Auth::guard('employer')->check()){
            return redirect()->route('employer.login');
        }
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            $jas = JA::where('jid',$id)->orderBy('created_at')->paginate(15);
            return view('employer.projects.applications')->with([
                'employer' => $em,
                'jas' => $jas,
                'id' => $id,
            ]);
        }
        else{
            Session()->flash('warning','You cannot view this project applications');
            return redirect()->back();
        }
    }
    public function shortlist($id,$uid){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            if(JA::where(['jid'=> $id, 'uid' => $uid])->exists()){
                if(Shortlisted::where(['jid'=> $id, 'uid' => $uid])->exists()){
                    Session()->flash('warning','This user is already shortlisted for the job');
                    return redirect()->back();
                }
                $sl = new Shortlisted;
                $sl->uid = $uid;
                $sl->jid = $id;
                $sl->save();
                $ja = JA::where(['jid'=> $id, 'uid' => $uid])->first();
                $ja->status = 1;
                $ja->save();
                Select::where(['jid'=> $id, 'uid' => $uid])->delete();
                Reject::where(['jid'=> $id, 'uid' => $uid])->delete();
                $user = User::find($uid);

                // Mail
                $sub = "You are shorlisted";
                $message="<p>Dear {$user->name},</p><p>You are shortlisted for the project <b>{$job->title}</b>.</p>";
                $data = array('sub'=>$sub,'message'=>$message);
                Mail::to($user->email)->send(new GlobalMail($data));

                Session()->flash('success','User is shortlisted');
                return redirect()->back();
            }
            else{
                Session()->flash('warning','You cannot shortlist this user for this project');
                return redirect()->back();
            }
        }
        else{
            Session()->flash('warning','You cannot shortlist user for this project');
            return redirect()->back();
        }
    }
    public function shortlistall(Request $request){
        $em = Employer::find(Auth::guard('employer')->id());
        $id = $request->id;
        $job = Project::find($request->id);
        if($job->user == $em->id){
            $jas = JA::where('jid',$id)->get();
            if($jas->count()==0){
                Session()->flash('error','There is no application found for this project');
                return redirect()->back();
            }
            else{
                foreach($jas as $ja){
                    $uid = $ja->uid;
                    
                    if(Shortlisted::where(['jid'=> $id, 'uid' => $uid])->exists()){
                        continue;
                    }
                    else{
                        $sl = new Shortlisted;
                        $sl->uid = $uid;
                        $sl->jid = $id;
                        $sl->save();
                        $ja = JA::where(['jid'=> $id, 'uid' => $uid])->first();
                        $ja->status = 1;
                        $ja->save();
                        Select::where(['jid'=> $id, 'uid' => $uid])->delete();
                        Reject::where(['jid'=> $id, 'uid' => $uid])->delete();
                        $user = User::find($uid);

                        // Mail
                        $sub = "You are shorlisted";
                        $message="<p>Dear {$user->name},</p><p>You are shortlisted for the project <b>{$job->title}</b>.</p>";
                        $data = array('sub'=>$sub,'message'=>$message);
                        Mail::to($user->email)->send(new GlobalMail($data));
                    }
                }
                Session()->flash('success','All the applications are shortlisted');
                return redirect()->back();
            }
        }
        else{
            Session()->flash('warning','You cannot shortlist user for this project');
            return redirect()->back();
        }
    }

    public function shortlisteds($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            $jas = Shortlisted::where('jid',$id)->orderBy('created_at')->paginate(15);
            return view('employer.projects.shortlisteds')->with([
                'employer' => $em,
                'jas' => $jas
            ]);
        }
        else{
            Session()->flash('warning','You cannot view this project applications');
            return redirect()->back();
        }
    }
    public function select($id,$uid){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            if(JA::where(['jid'=> $id, 'uid' => $uid])->exists()){
                if(Select::where(['jid'=> $id, 'uid' => $uid])->exists()){
                    Session()->flash('warning','This user is already selected for the job');
                    return redirect()->back();
                }
                $sl = new Select;
                $sl->uid = $uid;
                $sl->jid = $id;
                $sl->save();
                $ja = JA::where(['jid'=> $id, 'uid' => $uid])->first();
                $ja->status = 2;
                $ja->save();
                Reject::where(['jid'=> $id, 'uid' => $uid])->delete();
                $user = User::find($uid);

                // Mail
                $sub = "You are selected";
                $message="<p>Dear {$user->name},</p><p>You are selected for the project <b>{$job->title}</b></p>";
                $data = array('sub'=>$sub,'message'=>$message);
                Mail::to($user->email)->send(new GlobalMail($data));
                Session()->flash('success','User is selected');
                return redirect()->back();
            }
            else{
                Session()->flash('warning','You cannot select this user for this project');
                return redirect()->back();
            }
        }
        else{
            Session()->flash('warning','You cannot select user for this project');
            return redirect()->back();
        }
    }
    public function selectall(Request $request){
        $id = $request->id;
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            $jas = JA::where('jid',$id)->get();
            if($jas->count()==0){
                Session()->flash('error','No application found for this project');
                return redirect()->back();
            }
            else{
                foreach($jas as $ja){
                    $uid = $ja->uid;
                    if(Select::where(['jid'=> $id, 'uid' => $uid])->exists()){
                        continue;
                    }
                    else{
                        $sl = new Select;
                        $sl->uid = $uid;
                        $sl->jid = $id;
                        $sl->save();
                        $ja = JA::where(['jid'=> $id, 'uid' => $uid])->first();
                        $ja->status = 2;
                        $ja->save();
                        Reject::where(['jid'=> $id, 'uid' => $uid])->delete();
                        $user = User::find($uid);
            
                        // Mail
                        $sub = "You are selected";
                        $message="<p>Dear {$user->name},</p><p>You are selected for the project <b>{$job->title}</b></p>";
                        $data = array('sub'=>$sub,'message'=>$message);
                        Mail::to($user->email)->send(new GlobalMail($data));
                        Session()->flash('success','User is selected');
                        return redirect()->back();
                    }
                }
                Session()->flash('success','All the applications are selected');
                return redirect()->back();
            }
        }
        else{
            Session()->flash('warning','You cannot select user for this project');
            return redirect()->back();
        }
    }

    public function selecteds($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            $jas = Select::where('jid',$id)->orderBy('created_at')->paginate(15);
            return view('employer.projects.selecteds')->with([
                'employer' => $em,
                'jas' => $jas
            ]);
        }
        else{
            Session()->flash('warning','You cannot view this job applications');
            return redirect()->back();
        }
    }
    public function reject($id,$uid){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            if(JA::where(['jid'=> $id, 'uid' => $uid])->exists()){
                if(Reject::where(['jid'=> $id, 'uid' => $uid])->exists()){
                    Session()->flash('warning','This user is already rejected for the job');
                    return redirect()->back();
                }
                $sl = new Reject;
                $sl->uid = $uid;
                $sl->jid = $id;
                $sl->save();
                $ja = JA::where(['jid'=> $id, 'uid' => $uid])->first();
                $ja->status = 3;
                $ja->save();
                Select::where(['jid'=> $id, 'uid' => $uid])->delete();

                $user = User::find($uid);

                // Mail
                $sub = "You have been rejected";
                $message="<p>Dear {$user->name},</p><p>The employer has rejected you to take part in the project <b>{$job->title}</b></p>";
                $data = array('sub'=>$sub,'message'=>$message);
                Mail::to($user->email)->send(new GlobalMail($data));
                Session()->flash('success','User is rejected');
                return redirect()->back();
            }
            else{
                Session()->flash('warning','You cannot reject this user for this job');
                return redirect()->back();
            }
        }
        else{
            Session()->flash('warning','You cannot reject user for this job');
            return redirect()->back();
        }
    }
    public function rejectall(Request $request){
        $id = $request->id;
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        if($job->user == $em->id){
            $jas = JA::where('jid',$id)->get();
            if($jas->count()==0){
                Session()->flash('error','No application found for this project');
                return redirect()->back();
            }
            else{
                foreach($jas as $ja){
                    $uid = $ja->uid;
                    
                    if(Reject::where(['jid'=> $id, 'uid' => $uid])->exists()){
                        continue;
                    }
                    else{
                        $sl = new Reject;
                        $sl->uid = $uid;
                        $sl->jid = $id;
                        $sl->save();
                        $ja = JA::where(['jid'=> $id, 'uid' => $uid])->first();
                        $ja->status = 3;
                        $ja->save();
                        Select::where(['jid'=> $id, 'uid' => $uid])->delete();

                        $user = User::find($uid);

                        // Mail
                        $sub = "You have been rejected";
                        $message="<p>Dear {$user->name},</p><p>The employer has rejected you to take part in the project <b>{$job->title}</b></p>";
                        $data = array('sub'=>$sub,'message'=>$message);
                        Mail::to($user->email)->send(new GlobalMail($data));
                    }
                }
                Session()->flash('success','All the applications are rejected');
                return redirect()->back();
            }
        }
        else{
            Session()->flash('warning','You cannot reject user for this job');
            return redirect()->back();
        }
    }
    public function issue_certificate($jid,$uid){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($jid);
        $user = User::find($uid);
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $em->id){
            if(Certificate::where(['jid'=>$jid,'uid'=>$uid])->exists()){
                Session()->flash('warning','Certificate for this user is already issued');
                return redirect()->back();
            }
            else{
                //Sending Mail

                $data = array('user'=>$user->name,'job'=>$job->title,'jid'=>$jid,'uid'=>$uid);
                Mail::to($user->email)->send(new certificate_mail($data));

                
                $cert = new Certificate;
                $cert->uid = $uid;
                $cert->jid = $jid;
                $cert->save();
                $ja = JA::where(['jid'=> $jid, 'uid' => $uid])->first();
                $ja->status = 5;
                $ja->save();

                Session()->flash('success','Certificate sent to the user');
                return redirect()->back();
            }
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }

    public function proofs($jid,$uid){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($jid);
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $em->id){
            $proofs = JobProof::where(['uid' => $uid,'jid' => $jid])->first();
            return view('employer.projects.proofs')->with([
                'proofs' => $proofs,
            ]);
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }
    public function answers($jid,$uid){
        $employer = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($jid);
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $employer->id){
            $qus = QS::where(['pid' => $jid])->get();
            return view('employer.projects.answers')->with([
                'qus' => $qus,
                'uid' => $uid,
                'employer' => $employer,
            ]);
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }
    public function payout(Request $request,$jid){
        $this->validate($request,[
            'stipend'=>'required',
            'uid' => 'required'
        ]);
        $uid = $request->uid;
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($jid);
        $user = User::find($uid);
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $em->id){
            $user = User::find($uid);
            $user->balance = $user->balance+$request->stipend;
            $user->save();
            $tr = new Transition;
            $tr->uid = $user->id;
            $tr->reason = "For Completing the Project ".$job->title;
            $tr->transition = "+".$request->stipend;
            $tr->addm = $request->stipend;
            $tr->save();
            if($user->ref_by!=NULL):
                $userr = User::find($user->ref_by);
                $userr->balance = $userr->balance+($request->stipend*0.5);
                $userr->save();
                $tr = new Transition;
                $tr->uid = $userr->id;
                $tr->reason = "Referral Bonus";
                $tr->transition = "+".($request->stipend*0.5);
                $tr->addm = $request->stipend*0.5;
                $tr->save();
            endif;
            $ja = JA::where(['jid'=> $jid, 'uid' => $uid])->first();
            $ja->status = 6;
            $ja->save();
            // Mail
            $sub = "Payout";
            $message="<p>Dear {$user->name},</p><p>The employer has paid you for completing the project project <b>{$job->title}</b></p>";
            $data = array('sub'=>$sub,'message'=>$message);
            Mail::to($user->email)->send(new GlobalMail($data));
            $request->session()->flash('success', "Paid");
            return redirect()->back();
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }
    public function export_excel($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $em->id){
            $proofs = JobProof::where(['jid' => $id])->get();
            if($proofs->count()==0){
                Session()->flash('warning','No proof found');
                return redirect()->back();
            }
            else{
                return Excel::download(new ProjectProofs($id), 'proofs.xlsx');
            }
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }
    public function exportapps($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $em->id){
            $proofs = JA::where(['jid' => $id])->get();
            if($proofs->count()==0){
                Session()->flash('warning','No applications found');
                return redirect()->back();
            }
            else{
                return Excel::download(new EmPrApps($id), 'project_apps.xlsx');
            }
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }
    public function exportsls($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $em->id){
             $jas = Shortlisted::where('jid',$id)->get();
            if($jas->count()==0){
                Session()->flash('warning','No shortlisteds found');
                return redirect()->back();
            }
            else{
                return Excel::download(new EmPrSls($id), 'project_shortlisted.xlsx');
            }
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }
    public function exportsl($id){
        $em = Employer::find(Auth::guard('employer')->id());
        $job = Project::find($id);
        
        if($job==NULL){
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
        if($job->user == $em->id){
             $jas = Select::where('jid',$id)->get();
            if($jas->count()==0){
                Session()->flash('warning','No Selecteds found');
                return redirect()->back();
            }
            else{
                return Excel::download(new EmPrSl($id), 'project_selected.xlsx');
            }
        }
        else{
            Session()->flash('warning','You cannot perform this action');
            return redirect()->back();
        }
    }

}
