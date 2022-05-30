<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\CustomProject;
use App\CustomProjectCategory;
use App\CustomProjectForm;

class CustomProjectController extends Controller
{
    public function index(){
        $page = CustomProject::first();
        return view("admin.custom_project.page")->with([
            "page"=>$page
        ]);
    }
    public function page(Request $request){
        $this->validate($request,[
            "heading"=>"required",
            "description"=>"required",
            "image"=>"nullable",
        ]);
        $page = CustomProject::first();
        $page->heading = $request->heading;
        $page->description = $request->description;
        if($request->hasFile("image")){
            $path = "assets/custom_project/image/";
            $name = $_FILES["image"]["name"];
            $tmp_name = $_FILES["image"]["tmp_name"];
            if(move_uploaded_file($tmp_name,$path.$name)){
                if($page->image!==$name){
                    unlink($path.$page->image);
                }
                $page->image = $name;
            }
            else{
                $request->session()->flash('error', "There is some problem in uploading the image");
                return redirect()->back();
            }
        }
        $page->save();
        $request->session()->flash('success', "Page content updated");
        return redirect()->back();
    }
    public function categories(){
        $categories = CustomProjectCategory::latest()->paginate(15);
        return view("admin.custom_project.categories")->with([
            "categories"=>$categories
        ]);
    }
    public function category(Request $request){
        $this->validate($request,[
            "name"=>"required"
        ]);
        $category = new CustomProjectCategory;
        $category->category = $request->name;
        $category->save();
        $request->session()->flash('success', "Category created");
        return redirect()->back();
    }
    public function categoryDelete(Request $request){
        $this->validate($request,[
            "id"=>"required"
        ]);
        $category = CustomProjectCategory::find($request->id);
        if($category === NULL){
            $request->session()->flash('error', "The category does not exist");
        }
        else{
            $category->delete();
            $request->session()->flash('success', "Category deleted");
        }
        return redirect()->back();
    }
    public function forms(){
        $forms = CustomProjectForm::latest()->paginate(15);
        return view("admin.custom_project.forms")->with([
            "forms"=>$forms
        ]);
    }
    public function formsDelete(Request $request){
        $this->validate($request,[
            "id"=>"required"
        ]);
        $form = CustomProjectForm::find($request->id);
        if($form === NULL){
            $request->session()->flash('error', "The form does not exist");
        }
        else{
            if($form->resume!==NULL){
                $path = "assets/custom_project/resume/";
                unlink($path.$form->resume);
            }
            $form->delete();
            $request->session()->flash('success', "Form deleted");
        }
        return redirect()->back();
    }
}
