<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Telecalling;
use App\TelecallingApp;
use App\User;

class TelecallingController extends Controller
{
    public function list(){
        $telecallings = Telecalling::latest()->get();
        foreach ($telecallings as $tele ) {
            $path = "assets/telecalling/logo/";
            $logo = \file_get_contents($path.$tele->logo);
            $logo = \base64_encode($logo);
            $logoT = explode(".",$tele->logo)[1];
            $logo = "data:image/".$logoT.";base64,".$logo;
            $tele->logo = $logo;
            if($tele->script_img!==NULL){
                $path = "assets/telecalling/script_img/";
                $logo = \file_get_contents($path.$tele->script_img);
                $logo = \base64_encode($logo);
                $logoT = explode(".",$tele->script_img)[1];
                $logo = "data:image/".$logoT.";base64,".$logo;
                $tele->script_img = $logo;
            }
            if($tele->audio_file!==NULL){
                $path = "assets/telecalling/audio_file/";
                $logo = \file_get_contents($path.$tele->audio_file);
                $logo = \base64_encode($logo);
                $logoT = explode(".",$tele->audio_file)[1];
                $logo = "data:audio/".$logoT.";base64,".$logo;
                $tele->audio_file = $logo;
            }
            if($tele->obj_img!==NULL){
                $path = "assets/telecalling/obj_img/";
                $logo = \file_get_contents($path.$tele->obj_img);
                $logo = \base64_encode($logo);
                $logoT = explode(".",$tele->obj_img)[1];
                $logo = "data:image/".$logoT.";base64,".$logo;
                $tele->obj_img = $logo;
            }
        }
        return response()->json(["response"=>["code"=>"SUCCESS","telecallings"=>$telecallings]], 200);
    }
    public function details(Request $request){
        $this->validate($request,[
            'id' => 'required',
        ]);
        $telecalling = Telecalling::find($request->id);
        if($telecalling==NULL){
            return response()->json(['response'=>['code'=>'ERROR',"message"=>"TELECALLING PROJECT NOT FOUND"]], 200);
        }
        else{
            $path = "assets/telecalling/logo/";
            $logo = \file_get_contents($path.$telecalling->logo);
            $logo = \base64_encode($logo);
            $logoT = explode(".",$telecalling->logo)[1];
            $logo = "data:image/".$logoT.";base64,".$logo;
            $telecalling->logo = $logo;

            if($telecalling->script_img!==NULL){
                $path = "assets/telecalling/script_img/";
                $logo = \file_get_contents($path.$telecalling->script_img);
                $logo = \base64_encode($logo);
                $logoT = explode(".",$telecalling->script_img)[1];
                $logo = "data:image/".$logoT.";base64,".$logo;
                $telecalling->script_img = $logo;
            }

            if($telecalling->audio_file!==NULL){
                $path = "assets/telecalling/audio_file/";
                $logo = \file_get_contents($path.$telecalling->audio_file);
                $logo = \base64_encode($logo);
                $logoT = explode(".",$telecalling->audio_file)[1];
                $logo = "data:audio/".$logoT.";base64,".$logo;
                $telecalling->audio_file = $logo;
            }

            if($telecalling->obj_img!==NULL){
                $path = "assets/telecalling/obj_img/";
                $logo = \file_get_contents($path.$telecalling->obj_img);
                $logo = \base64_encode($logo);
                $logoT = explode(".",$telecalling->obj_img)[1];
                $logo = "data:image/".$logoT.";base64,".$logo;
                $telecalling->obj_img = $logo;
            }
            return response()->json(['response'=>['code'=>'SUCCESS','telecalling'=>$telecalling]], 200);
        }
    }
    public function apply(Request $request){
        $this->validate($request,[
            "id" => "required",
            "uid" => "required",
        ]);
        $telecalling = Telecalling::find($request->id);
        if($telecalling==NULL){
            return response()->json(['response'=>['code'=>'ERROR',"message"=>"TELECALLING PROJECT NOT FOUND"]], 200);
        }
        else{
            if(User::find($request->uid)===NULL){
                return response()->json(['response'=>['code'=>'ERROR',"message"=>"USER NOT FOUND"]], 200);
            }
            else{    
                if(TelecallingApp::where(["tid"=>$request->id,"uid"=>$request->uid])->exists()){
                    return response()->json(['response'=>['code'=>'ERROR',"message"=>"THE USER HAS ALREADY APPLIED TO THE PROJECT"]], 200);
                }
                else{
                    $tele = new TelecallingApp;
                    $tele->uid = $request->uid;
                    $tele->tid = $request->id;
                    $tele->save();
                    return response()->json(['response'=>['code'=>'SUCCESS','message'=>"SUCCESSFULLY APPLIED"]], 200);
                }
            }
        }
    }
    public function applications(Request $request){
        $this->validate($request,[
            "uid" => "required"
        ]);
        $user = User::find($request->uid);
        if($user===NULL){
            return response()->json(['response'=>['code'=>'ERROR',"message"=>"USER NOT FOUND"]], 200);
        }
        else{
            $applications = TelecallingApp::where(["uid"=>$request->uid])->latest()->get();
            return response()->json(['response'=>['code'=>'SUCCESS','applications'=>$applications]], 200);
        }
    }
    public function status(Request $request){
        $this->validate($request,[
            "id" => "required",
            "uid" => "required",
        ]);
        $telecalling = Telecalling::find($request->id);
        if($telecalling==NULL){
            return response()->json(['response'=>['code'=>'ERROR',"message"=>"TELECALLING PROJECT NOT FOUND"]], 200);
        }
        else{
            if(User::find($request->uid)===NULL){
                return response()->json(['response'=>['code'=>'ERROR',"message"=>"USER NOT FOUND"]], 200);
            }
            else{ 
                if(TelecallingApp::where(["tid"=>$request->id,"uid"=>$request->uid])->exists()){
                    $application = TelecallingApp::where(["tid"=>$request->id,"uid"=>$request->uid])->first();
                    return response()->json(['response'=>['code'=>'SUCCESS',"application"=>$application]], 200);
                }
                else{
                    return response()->json(['response'=>['code'=>'ERROR',"message"=>"THE USER HAS NOT APPLIED TO THE PROJECT"]], 200);
                }
            }
        }
    }
    public function feedback(Request $request){
        $this->validate($request,[
            "id" => "required",
            "uid" => "required",
            "call_status" => "required",
            "session_time" => "nullable",
            "minutes" => "nullable",
            "caller_name" => "required",
            "caller_phone" => "required",
            "feedback" => "nullable",
        ]);
        $telecalling = Telecalling::find($request->id);
        if($telecalling==NULL){
            return response()->json(['response'=>['code'=>'ERROR',"message"=>"TELECALLING PROJECT NOT FOUND"]], 200);
        }
        else{
            if(User::find($request->uid)===NULL){
                return response()->json(['response'=>['code'=>'ERROR',"message"=>"USER NOT FOUND"]], 200);
            }
            else{ 
                if(TelecallingApp::where(["tid"=>$request->id,"uid"=>$request->uid])->exists()){
                    $application = TelecallingApp::where(["tid"=>$request->id,"uid"=>$request->uid])->first();
                    if($application->status===3 or $application->status===4):
                        $feedback = json_decode($application->feedback);
                        $i=0;
                        if($feedback!==NULL){
                            $i = count($feedback);
                        }
                        $feedback[$i]["caller_name"] = $request->caller_name;
                        $feedback[$i]["caller_phone"] = $request->caller_phone;
                        $feedback[$i]["feedback"] = $request->feedback;
                        $feedback[$i]["call_status"] = $request->call_status;
                        $feedback[$i]["session_time"] = $request->session_time;
                        $feedback[$i]["minutes"] = $request->minutes;
                        $application->feedback = json_encode($feedback,true);
                        $application->status = 4;
                        $application->save();
                    else:
                        return response()->json(['response'=>['code'=>'ERROR',"message"=>"THE USER IS NOT SELECTED FOR THE PROJECT"]], 200);
                    endif;

                    return response()->json(['response'=>['code'=>'SUCCESS',"message"=>"FEEDBACK SUBMITTED"]], 200);
                }
                else{
                    return response()->json(['response'=>['code'=>'ERROR',"message"=>"THE USER HAS NOT APPLIED FOR THE PROJECT"]], 200);
                }
            }
        } 
    }
}
