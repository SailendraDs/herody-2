<?php

namespace App\Http\Controllers\Manager;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Work;
use App\Employer;
use App\Mail\GlobalMail;
use Illuminate\Support\Facades\Mail;
use Excel;
use App\Exports\AllWorks;


use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class WorkController extends Controller
{
    public function pending(){
        if(!Auth::guard('manager')->check()){
            return redirect('/');
        }
        $works = Work::where("approved",0)->latest()->paginate(15);
        return view('manager.work.pending')->with([
            'works' => $works
        ]);
    }

    public function all(){
        if(!Auth::guard('manager')->check()){
            return redirect('/');
        }
        $works = Work::where("approved",1)->orderBy('created_at')->paginate(15);
        return view('manager.work.all')->with([
            'works' => $works
        ]);
    }

    public function approve(Request $request){
        if(!Auth::guard('manager')->check()){
            return redirect('/');
        }
        $pending = Work::find($request->id);
        $pending->approved=1;
        $pending->save();

        // Mail
        $sub = "Your Work has been accepted";
        $message="<p>Dear {$pending->employer->name},</p><p>Your work, {$pending->name}, has been accepted by manager.</p>";
        $data = array('sub'=>$sub,'message'=>$message);
        Mail::to($pending->employer->email)->send(new GlobalMail($data));
        
        Session()->flash('success','Work Approved');
        return redirect()->back();
    }

    public function delete(Request $request){
        if(!Auth::guard('manager')->check()){
            return redirect('/');
        }
        $pending = Work::find($request->id);
        $pending->objectives = json_decode($pending->objectives);
        foreach($pending->objectives as $obj){
            $path = "assets/work/files/";
            unlink($path.$obj->file);
        }
        $job = $pending;
        $pending->delete();

        // Mail
        $sub = "Your Work has been rejected";
        $message="<p>Dear {$job->employer->name},</p><p>Your work, {$job->name}, has been rejected by manager.</p>";
        $data = array('sub'=>$sub,'message'=>$message);
        Mail::to($job->employer->email)->send(new GlobalMail($data));

        Session()->flash('success','Work Deleted');
        return redirect()->back();
    }
    public function export_excel(){
        $works = Work::get();
        if($works->count()==0){
            Session()->flash('warning','No work found');
            return redirect()->back();
        }
        else{
            return Excel::download(new AllWorks(), 'works.xlsx');
        }
    }
}
