<?php

namespace App\Http\Controllers\API\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;

class MainController extends Controller
{
    public function login(Request $request){
        $this->validate($request,[
            'email' => 'required',
            'password' => 'required',
        ]);
        $user = User::where('email',$request->email)->first();
        if($user==NULL){
            return response()->json(['response'=>['code'=>'EMAIL NOT CORRECT']], 401);
        }
        else{
            if(Hash::check($request->password, $user->password)){
                return response()->json(['response'=>['code'=>'SUCCESS','user' => $user]], 200);
            }
            else{
                return response()->json(['response'=>['code'=>'PASSWORD NOT CORRECT']], 401);
            }
        }
    }
    public function register(Request $request){
        $this->validate($request,[
            'email' => 'required',
            'name' => 'required',
            'password' => 'required',
            'phone' => 'required',
            'ref_by' => 'nullable',
            'password_confirmation' => 'required',
        ]);
        $user = User::where('email',$request->email)->first();
        if($user==NULL){
            if($request->ref_by!=NULL){
                if(\App\User::where('ref_code',$request->ref_by)->exists()){
                    $user = User::where('ref_code',$request->ref_by)->first();
                    $ref_by = $user->id;
                }
                else{
                    return response()->json(['response'=>['code'=>'REFRAL CODE DOES NOT EXIST']], 401);
                    $ref_by=NULL;
                }
            }
            else{
                $ref_by = NULL;
            }
            while(true){
                $ref_code = $this->randstr(5);
                if(User::where('ref_code',$ref_code)->exists()){

                }
                else{
                    break;
                }
            }
            if($request->password==$request->password_confirmation){
                $user = User::create([
                    'name' => $request->name,
                    'email' => $request->email,
                    'user_name' => $request->email,
                    'phone' => $request->phone,
                    'password' => Hash::make($request->password),
                    'ref_by' => $ref_by,
                    'ref_code' => $ref_code,
                ]);
                // $user->sendEmailVerificationNotification();
                return response()->json(['response'=>['code'=>'SUCCESS','user' => $user]], 200);
            }
            else{
                return response()->json(['response'=>['code'=>'PASSWORDS DO NOT MATCH']], 401);
            }
        }
        else{
            return response()->json(['response'=>['code'=>'EMAIL ALREADY EXISTS']], 401);
        }
    }
    public function randstr ($len=10, $abc="aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789") 
    {
        $letters = str_split($abc);
        $str = "";
        for ($i=0; $i<=$len; $i++) {
            $str .= $letters[rand(0, count($letters)-1)];
        };
        return $str;
    }
    public function loginTC(Request $request){
        $this->validate($request,[
            'name' => 'required',
            'email' => 'required',
            'phone' => 'required',
        ]);
        $name = $request->name;
        $email = $request->email;
        $phone = $request->phone;
        $pass = $this->randstr(14);
        $user = User::where('email',$email)->first();
        if($user==NULL){
            while(true){
                $ref_code = $this->randstr(5);
                if(User::where('ref_code',$ref_code)->exists()){

                }
                else{
                    break;
                }
            }
            $user = new User;
            $user->email = $email;
            $user->user_name = $email;
            $user->name = $name;
            $user->phone = $phone;
            $user->password = Hash::make($pass);
            $user->ref_code = $ref_code;
            $user->email_verified_at = \Carbon\Carbon::now()->format('Y-m-d H:i:s');
            $user->save();
            return response()->json(['response'=>['code'=>'SUCCESS','user'=>$user]], 200);
        }
        else{
            return response()->json(['response'=>['code'=>'SUCCESS','user'=>$user]], 200);
        }
    }
    public function verifyMobile(Request $request){
        $this->validate($request,[
            'uid' => 'required'
        ]);
        $user = User::find($request->uid);
        $user->app_status=1;
        $user->save();
        return response()->json(['response'=>['code'=>'SUCCESS']], 200);
    }
    public function forgotPassword(Request $request){
        $this->validate($request,[
            'email' => 'required',
        ]);
        $user = User::where('email', request()->input('email'))->first();
        $token = Password::getRepository()->create($user);
        $user->sendPasswordResetNotification($token);
        return response()->json(['response'=>['code'=>'SUCCESS']], 200);
    }

    public function getSession(Request $request){
        Auth::loginUsingId($request->id);
        $id = session()->get('name');
        return response()->json(['response'=>['code'=>'SUCCESS','id'=>$id]], 200);
    }
    public function emailVerified(Request $request){
        $this->validate($request,[
            'id' => 'required'
        ]);
        $user = User::find($request->id);
        $user->email_verified_at = \Carbon\Carbon::now()->format('Y-m-d H:i:s');
        $user->save();
        return response()->json(['response'=>['code'=>'SUCCESS']], 200);
    }
}
