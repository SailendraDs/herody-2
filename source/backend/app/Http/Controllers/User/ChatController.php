<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Chat;
use App\Support;
use App\Admin;
use Auth;

class ChatController extends Controller
{
    public function index(){
        $chats = Chat::where(["sender_id"=>Auth::user()->id,"sender_type"=>"User"])
                        ->orWhere(function($query) {
                            $query->where('receiver_id', Auth::user()->id)
                                ->where('receiver_type', "User");
                        })->latest()->get();
        return view("user.chats.index")->with([
            "chats" => $chats,
        ]);
    }
    public function support(){
        $admin = Admin::first();
        $messages = [];
        return view("user.chats.messages")->with([
            "receiver_id" => $admin->id,
            "messages" => $messages,
            "receiver_type" => "Support",
            "status" => NULL,
            "support_id" => NULL,
        ]);
    }

    public function sendMessage(Request $request){
        $this->validate($request,[
            "receiver_id" => "required",
            "receiver_type" => "required",
            "message" => "required",
            "support_id" => "nullable",
        ]);
        $chat = new Chat;
        $chat->receiver_id = $request->receiver_id;
        $chat->message = $request->message;
        $chat->receiver_type = $request->receiver_type;
        $chat->sender_id = Auth::user()->id;
        $chat->sender_type = "User";
        $chat->support_id = $request->support_id;
        $chat->save();
        $request->session()->flash('success', "Message has been sent");
        return redirect()->back();
    }
    public function messages($type,$id,$page=1){
        $messages = Chat::where(["sender_id"=>Auth::user()->id,"sender_type"=>"User","receiver_type"=>$type,"receiver_id"=>$id])
                        ->orWhere(function($query) use ($type,$id) {
                            $query->where('receiver_id', Auth::user()->id)
                                ->where('receiver_type', "User")
                                ->where('sender_type', $type)
                                ->where('sender_id', $id);
                        })->latest()->paginate(15);
        $support_id = NULL;
        if(count($messages)>0):
            foreach ($messages as $message ) {
                $support_id = $message->support_id;
                if($message->receiver_id===Auth::user()->id){
                    $message->isseen = 1;
                    $message->save();
                }
            }
        endif;
        $status = NULL;
        if($support_id!==NULL){
            $support = Support::find($support_id);
            $status = $support->status;
        }
        if($type === "Support"){
            $name = "Support";
            $image = "assets/main/images/logo-dark.png";
        }
        else if($type === "User"){
            $name = \App\User::find($id)->name;
            $image = \App\User::find($id)->profile_photo===NULL? 'assets/user/images/frontEnd/demo.png' :"assets/user/images/user_profile/".\App\User::find($id)->profile_photo;
        }
        else if($type === "Company"){
            $name = \App\Employer::find($id)->name;
            $image = "assets/employer/profile_images/".(\App\Employer::find($id)->profile_photo ?? "default.png");
        }
        return view("user.chats.messages")->with([
            "receiver_id" => $id,
            "messages" => $messages,
            "receiver_type" => $type,
            "receiver_image" => $image,
            "status" => $status,
            "support_id" => $support_id,
        ]);
    }
}
