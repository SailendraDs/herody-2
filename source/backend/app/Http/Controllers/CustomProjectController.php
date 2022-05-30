<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\CustomProject;
use App\CustomProjectCategory;
use App\CustomProjectForm;

class CustomProjectController extends Controller
{
    public function index(){
        $page = CustomProject::first();
        $categories = CustomProjectCategory::latest()->paginate(15);
        return view("custom_project.index")->with([
            "page"=>$page,
            "categories"=>$categories,
        ]);
    }
    public function form(Request $request){
        $this->validate($request,[
            "name"=>"required",
            "email"=>"required",
            "phone"=>"required",
            "website"=>"required",
            "startup"=>"nullable",
            "facebook"=>"required",
            "instagram"=>"required",
            "linkedin"=>"required",
            "resume"=>"required|mimes:pdf",
            "category"=>"required",
            "description"=>"required",
        ]);
        $form = new CustomProjectForm;
        $form->name = $request->name;
        $form->email = $request->email;
        $form->phone = $request->phone;
        $form->startup = $request->startup;
        $form->website = $request->website;
        $form->facebook = $request->facebook;
        $form->instagram = $request->instagram;
        $form->linkedin = $request->linkedin;
        $form->category_id = $request->category;
        $form->description = $request->description;
        
        $path = "assets/custom_project/resume/";
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
