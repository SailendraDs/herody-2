<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Employer;
use App\User;
use App\Pending;
use App\ProjectApps as JA;
use App\Project;
use App\Shortlisted;
use App\Select;
use App\Reject;
use App\Skill;
use App\Education;
use App\Experiences;
use App\UserProject;
use App\Certificate;
use Image;


use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class ApplicantController extends Controller
{
    public function index($id){
        if((!Auth::check()) and (!Auth::guard('employer')->check()) and (!Auth::guard('admin')->check()) and (!Auth::guard('manager')->check())){
            return redirect()->back();
        }
        $user = User::find($id);
        if($user == NULL){
            Session()->flash('warning','The user does not exist!');
            return redirect()->back();
        }
        $exps = Experiences::where('uid',$user->id)->get();
        $skills = Skill::where('uid',$user->id)->get();
        $edus = Education::where('uid',$user->id)->get();
        $projs = UserProject::where('uid',$user->id)->get();
        return view('applicants.view')->with([
            'user' => $user,
            'exps' => $exps,
            'edus' => $edus,
            'projs' => $projs,
            'skills' => $skills,
        ]);
    }
    public function printv($id){
        if((!Auth::check()) and (!Auth::guard('employer')->check()) and (!Auth::guard('admin')->check()) and (!Auth::guard('manager')->check())){
            return redirect()->back();
        }
        $user = User::find($id);
        if($user == NULL){
            Session()->flash('warning','The user does not exist!');
            return redirect()->back();
        }
        $exps = Experiences::where('uid',$user->id)->get();
        $skills = Skill::where('uid',$user->id)->get();
        $edus = Education::where('uid',$user->id)->get();
        $projs = UserProject::where('uid',$user->id)->get();
        return view('applicants.print-view')->with([
            'user' => $user,
            'exps' => $exps,
            'edus' => $edus,
            'projs' => $projs,
            'skills' => $skills,
        ]);
    }
    public function printc($jid,$uid){
        $user = User::find($uid);
        $job = Project::find($jid);
        $emp = Employer::find($job->user);
        if(Certificate::where(['uid'=>$uid,'jid'=>$jid])->exists()){
            if(Auth::check()){
                if(Auth::user()->id==$uid){
                    return view('applicants.certificate')->with([
                        'user' => $user,
                        'job' => $job,
                        'emp' => $emp,
                    ]);
                }
                else{
                    return redirect()->back();
                }
            }
            else{
                return redirect()->back();
            }
        }
        else{
            return redirect()->back();
        }
    }
    public function print($id){
        if((!Auth::check()) and (!Auth::guard('employer')->check()) and (!Auth::guard('admin')->check()) and (!Auth::guard('manager')->check())){
            return redirect()->back();
        }
        $user = User::find($id);
        if($user == NULL){
            Session()->flash('warning','The user does not exist!');
            return redirect()->back();
        }
        $exps = Experiences::where('uid',$user->id)->get();
        $skills = Skill::where('uid',$user->id)->get();
        $edus = Education::where('uid',$user->id)->get();
        $projs = UserProject::where('uid',$user->id)->get();
        $data = [
            'user' => $user,
            'exps' => $exps,
            'edus' => $edus,
            'projs' => $projs,
            'skills' => $skills,
        ];
        $pdf = \App::make('pdflayer');
        return $pdf->loadView('applicants/pdf_view', $data)->setAccessKey('25a1bb7308537dd7720b1f0bc721b2db')->stream('download.pdf');
    }
}
