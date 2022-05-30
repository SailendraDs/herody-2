<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\JoinTeam;
use App\JoinTeamCategory;
use App\JoinTeamForm;

class JoinTeamController extends Controller
{
    public function index(){
        $page = JoinTeam::first();
        $categories = JoinTeamCategory::latest()->paginate(15);
        return view("join_team.index")->with([
            "page"=>$page,
            "categories"=>$categories,
        ]);
    }
    public function form(Request $request){
        $this->validate($request,[
            "name"=>"required",
            "email"=>"required",
            "phone"=>"required",
            "linkedin"=>"required",
            "resume"=>"required|mimes:pdf",
            "category"=>"required",
            "description"=>"required",
        ]);
        $form = new JoinTeamForm;
        $form->name = $request->name;
        $form->email = $request->email;
        $form->phone = $request->phone;
        $form->linkedin = $request->linkedin;
        $form->category_id = $request->category;
        $form->description = $request->description;
        
        $path = "assets/join_team/resume/";
        $resume = $_FILES["resume"]["name"];
        $tmp_resume = $_FILES["resume"]["tmp_name"];
        $resume = idate("U").$resume;
        if(\move_uploaded_file($tmp_resume,$path.$resume)){
            $form->resume = $resume;
            $form->save();
            $request->session()->flash('success', "Details sent");
            return redirect()->back();
        }
        else{
            $request->session()->flash('error', "There is some problem in uploading your resume");
            return redirect()->back();
        }
    }
}
