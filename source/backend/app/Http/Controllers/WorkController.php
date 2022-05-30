<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Work;
use App\Application;
use App\Employer;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class WorkController extends Controller
{
    public function list(){
        $works = Work::where("approved",1)->latest()->paginate(10);
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
        return view('works.list')->with([
            'works' => $works,
            'cats' => $cats,
        ]);
    }
    public function cat(Request $request){
        $this->validate($request,[
            'cat' => 'required'
        ]);
        if($request->cat=="All"){
            return redirect('works');
        }
        else{
            $works = Work::where(['category'=>$request->cat,"approved"=>1])->latest()->paginate(30);
        }
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
        return view('works.list')->with([
            'works' => $works,
            'cats' => $cats,
        ]);
    }
    public function details($id,$name){
        $work = Work::find($id);
        if($work==NULL){
            abort(404);
        }
        else{
            if(md5($work->name)===$name){
                $work->objectives = \json_decode($work->objectives);
                $work->responsibilities = \json_decode($work->responsibilities);
                $work->questions = \json_decode($work->questions);
                return view('works.details')->with([
                    'work' => $work,
                ]);
            }
            else{
                abort(404);
            }
        }
    }
    public function apply(Request $request){
        $this->validate($request,[
            'id' => 'required',
            'answers' => 'required',
        ]);
        $id = $request->id;
        $work = Work::find($id);
        if($work==NULL){
            Session()->flash('error','The work does not exist');
            return redirect()->back();
        }
        else{
            if($work->applications->where("user_id",Auth::user()->id)->first()!==NULL){
                Session()->flash('error','You have already applied to the work');
                return redirect()->back();
            }
            else{
                $application = new Application;
                $application->user_id = Auth::user()->id;
                $application->work_id = $id;
                $application->status = 0;
                $application->answers = \json_encode($request->answers);
                $application->save();
                Session()->flash('success','Applied for the work');
                return redirect()->back();
            }
        }
    }
}
