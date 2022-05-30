<?php

namespace App\Http\Controllers\Manager;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Employer;
use Illuminate\Support\Facades\Auth;

class EmployerController extends Controller
{
    public function index(){
        $employers = Employer::paginate(15);
        return view('manager.employers.index')->with([
            'employers' => $employers,
        ]);
    }
    public function login(Request $request){
        $this->validate($request,[
            'id' => 'required',
        ]);
        $emp = Employer::find($request->id);
        if($emp==NULL){
            $request->session()->flash('error', "The employer does not exist");
            return redirect()->back();
        }
        else{
            if(Auth::guard('employer')->check()){
                Auth::guard('employer')->logout();
            }
            Auth::guard('employer')->login($emp);
            return redirect()->route('employer.dashboard');
        }
    }
}
