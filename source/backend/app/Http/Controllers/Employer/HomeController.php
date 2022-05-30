<?php

namespace App\Http\Controllers\Employer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Employer;
use App\User;
use App\Mail\EmpEmailVer;
use Illuminate\Support\Facades\Mail;


use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class HomeController extends Controller
{
    public function to_register(){
        if (Auth::guard('employer')->check()) {
            return redirect()->route('employer.dashboard');
        }

        return view('employer.auth.register');
    }
    public function to_login(){
        if (Auth::guard('employer')->check()) {
            return redirect()->route('employer.dashboard');
        }

        return view('employer.auth.login');
    }
    public function register(Request $request){
        $this->validate($request,[
            'fname' => 'required|max:50',
            'lname' => 'required|max:50',
            'email' => 'required',
            'phone' => 'required',
            'password' => 'required|min:5',
            'password_confirmation' => 'required|min:5',
        ]);
        if($request->input('password')!=$request->input('password_confirmation')){
            Session()->flash('error','Passwords doesnot match');
            return redirect()->back();
        }
        if(Employer::where('email',$request->email)->exists()){
            Session()->flash('error', "The email already exists");
            return redirect()->back();
        }
        $name = $request->fname." ".$request->lname;
        $em = new Employer;
        $em->name = $name;
        $em->email = $request->input('email');
        $em->phone = $request->input('phone');
        $em->password = Hash::make($request->input('password'));
        $em->save();
        $otp = rand(100000,9999999);
        $data = array('user'=>$em->name,'otp' => $otp);
        Mail::to($request->email)->send(new EmpEmailVer($data));
        Auth::guard('employer')->login($em);

        Session()->flash('success','You are registered');
        return view('employer.auth.verify_email')->with([
            'otp' => Hash::make($otp),
        ]);
    }
    public function login(Request $request){
        $this->validate($request, [
            'email' => 'required',
            'password' => 'required|min:5'
        ]);

        if (Auth::guard('employer')->attempt(['email' => $request->email, 'password' => $request->password], $request->get('remember'))) {

            //redirect
            Session()->flash('success', 'You are successfully logged in !');
            return redirect()->route('employer.dashboard');
        } else {
            //redirect
            Session()->flash('warning', 'Please enter correct email and password!');
            return redirect()->route('employer.login');
        }
    }
    public function logout()
    {
        Auth::guard('employer')->logout();
        return redirect()->route('employer.login');
    }

    public function resendemail(){
        if (Auth::guard('employer')->check()) {
            $emp = Employer::find(Auth::guard('employer')->id());
            $otp = rand(100000,9999999);
            $data = array('user'=>$emp->name,'otp' => $otp);
            Mail::to($emp->email)->send(new EmpEmailVer($data));

            Session()->flash('success','OTP resent');
            return view('employer.auth.verify_email')->with([
                'otp' => Hash::make($otp),
            ]);
        }
        return view('employer.login');
    }

    public function brand(Request $request){
        $this->validate($request,[
            'otp' => 'required',
            'otpv' => 'required',
        ]);
            $emp = Employer::find(Auth::guard('employer')->id());
            if(Hash::check($request->otp, $request->otpv)){
                $emp->email_verified = 1;
                $emp->save();
                Session()->flash('success','OTP Verified');
                return redirect()->route('employer.brand');
            }
            else{
                Session()->flash('error','OTP not correct');
                return redirect()->back()->with([
                    'otp' => $request->otpv,
                ]);
            }
    }
}
