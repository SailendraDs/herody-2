<?php

namespace App\Http\Controllers\Manager;
use App\Manager;
use App\Work;
use App\User;
use App\Withdraw;
use App\WithdrawRequest;
use Carbon\Carbon;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class HomeController extends Controller
{
    public function index()
    {
        if (Auth::guard('manager')->check()) {
            return redirect()->route('manager.dashboard');
        }

        return view('manager.auth.login');

    }
    public function login(Request $request)
    {
        //validation
        $this->validate($request, [
            'userName' => 'required',
            'password' => 'required|min:5'
        ]);

        if (Auth::guard('manager')->attempt(['userName' => $request->userName, 'password' => $request->password], $request->get('remember'))) {

            //redirect
            Session()->flash('success', 'You are successfully logged in !');
            return redirect()->route('manager.dashboard');
        } else {
            //redirect
            Session()->flash('warning', 'Please enter correct email and password!');
            return redirect()->route('manager');
        }
    }

    //logout
    public function logout()
    {
        Auth::guard('manager')->logout();
        return redirect()->route('manager');
    }

    //change password
    public function changePassword()
    {

        return view('manager.auth.changeManagerPassword');
    }

    //password update
    public function PasswordUpdate(Request $request)
    {
        //validation
        $this->validate($request, [
            'current_password' => 'required',
            'password' => 'required|min:5|confirmed'
        ]);


        $ManagerPassword = Auth::guard('manager')->user()->password;

        if (password_verify($request->current_password, $ManagerPassword)) {

            //update query
            $userId = Auth::guard('manager')->id();

            $manager = Manager::find($userId);

            $manager->password = Hash::make($request->password);
            $manager->save();

            //redirect
            Session()->flash('success', 'Password Change successful!');
            return redirect()->back();
        } else {
            //redirect
            Session()->flash('warning', 'Please enter correct password!');
            return redirect()->back();

        }
    }
}
