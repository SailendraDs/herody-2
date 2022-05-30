<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Application;
use App\Work;
use Auth;

class WorkController extends Controller
{
    public function works(){
        $works = Application::where(["user_id"=>Auth::user()->id])->latest()->paginate(10);
        return view("user.works.index")->with([
            "works"=>$works,
        ]);
    }
    public function work($id){
        $work = Application::find($id);
        if($work===NULL){
            abort(404);
        }
        else{
            if($work->user_id!==Auth::user()->id){
                return abort(404);
            }
            $work->work->objectives = json_decode($work->work->objectives);
            $work->files = json_decode($work->files);
            return view("user.works.work")->with([
                "work"=>$work,
            ]);
        }
    }
    public function objective($id,Request $request){
        $work = Application::find($id);
        if($work===NULL){
            abort(404);
        }
        else{
            if($work->user_id!==Auth::user()->id){
                abort(404);
            }
            else{
                $this->validate($request,[
                    "obj_file"=>"required",
                    "obj_id"=>"required",
                ]);
                $file = $_FILES["obj_file"]["name"];
                $tmp_file = $_FILES["obj_file"]["tmp_name"];
                $file = idate("U").$file;
                $path = "assets/user/work/";
                if(\move_uploaded_file($tmp_file,$path.$file)){
                    $files = array(
                        $request->obj_id=>[
                            "file"=>$file,
                        ]
                    );
                    $fl = (array)json_decode($work->files);
                    if($fl === NULL){
                        $fl = $files;
                    }
                    else{
                        $fl = array_merge($fl,$files);
                    }
                    $work->files = $fl;
                    $work->save();
                    $request->session()->flash('success', "File uploaded");
                    return redirect()->back();
                }
                else{
                    $request->session()->flash('error', "Some problem occured while uploading the file");
                    return redirect()->back();
                }
            }
        }
    }
    public function whole($id,Request $request){
        $work = Application::find($id);
        if($work===NULL){
            abort(404);
        }
        else{
            if($work->user_id!==Auth::user()->id){
                abort(404);
            }
            else{
                $this->validate($request,[
                    "obj_file"=>"required",
                    "obj_id"=>"required",
                ]);
                foreach($request->obj_id as $key => $id){
                    $file = $_FILES["obj_file"]["name"][$key];
                    $tmp_file = $_FILES["obj_file"]["tmp_name"][$key];
                    $file = idate("U").$file;
                    $path = "assets/user/work/";
                    if(\move_uploaded_file($tmp_file,$path.$file)){
                        $files = array(
                            $id=>[
                                "file"=>$file,
                            ]
                        );
                        $fl = $work->files;
                        if($fl === NULL){
                            $fl = $files;
                        }
                        else{
                            $fl = array_merge($fl,$files);
                        }
                        $work->files = $fl;
                    }
                    else{
                        $request->session()->flash('error', "Some problem occured while uploading a file");
                        return redirect()->back();
                    }
                }
                $work->save();
                $request->session()->flash('success', "Files uploaded");
                return redirect()->back();
            }
        }
    }
}
