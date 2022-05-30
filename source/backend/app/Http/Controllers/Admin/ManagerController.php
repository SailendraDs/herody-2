<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Manager;
use Illuminate\Support\Facades\Hash;

class ManagerController extends Controller
{
    public function index(){
        $managers = Manager::paginate(15);
        return view('admin.managers.index')->with([
            'managers' => $managers
        ]);
    }
    public function create(Request $request){
        $this->validate($request,[
            'name' => 'required',
            'email' => 'required',
            'username' => 'required',
            'password' => 'required',
            'phone' => 'required',
            'team_id' => 'required',
        ]);
        $manager = new Manager;
        $manager->name = $request->name;
        $manager->email = $request->email;
        $manager->username = $request->username;
        $manager->password = Hash::make($request->password);
        $manager->phone = $request->phone;
        $manager->team_id = $request->team_id;
        $manager->manager_id = "Manager_".$manager->id;
        $manager->save();
        $request->session()->flash('success', "Successfully Created");
        return redirect()->back();
    }
    public function delete(Request $request){
        $this->validate($request,[
            'id' => 'required',
        ]);
        Manager::find($request->id)->delete();
        $request->session()->flash('success', 'Deleted Successfully');
        return redirect()->back();
    }
}
