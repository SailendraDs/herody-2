<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Support;
use App\Chat;

class SupportController extends Controller
{
    public function index(){
        $supports = Support::latest()->paginate(10);
        return view("admin.support.index")->with([
            "supports" => $supports,
        ]);
    }
    public function delete(Request $request){
        $this->validate($request,[
            "id" => "required",
        ]);
        Chat::where("support_id",$request->id)->delete();
        Support::find($request->id)->delete();
        $request->session()->flash('success', "Support and chats successfully deleted");
        return redirect()->back();
    }
}
