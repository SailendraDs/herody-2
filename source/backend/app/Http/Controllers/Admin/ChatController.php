<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Admin;
use App\Chat;
use App\Support;
use Auth;
use App\Manager;

class ChatController extends Controller
{
    public function index(){
        $chats = Chat::where(["sender_id"=>Auth::guard("admin")->id(),"sender_type"=>"Support"])->whereNull('support_id')
                        ->orWhere(function($query) {
                            $query->where('receiver_id', Auth::guard("admin")->id())
                                ->where('receiver_type', "Support")
                                ->whereNull('support_id');
                        })->latest()->get();
        $teams = Manager::latest()->get();
        return view("admin.chats.index")->with([
            "chats" => $chats,
            "teams" => $teams,
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
        $chat->sender_id = Auth::guard("admin")->id();
        $chat->sender_type = "Support";
        $chat->support_id = $request->support_id;
        $chat->save();
        $request->session()->flash('success', "Message has been sent");
        return redirect()->back();
    }
    public function messages($type,$id){
        $messages = Chat::where(["sender_id"=>Auth::guard("admin")->id(),"sender_type"=>"Support","receiver_type"=>$type,"receiver_id"=>$id])
                        ->orWhere(function($query) use ($type,$id) {
                            $query->where('receiver_id', Auth::guard("admin")->id())
                                ->where('receiver_type', "Support")
                                ->where('sender_type', $type)
                                ->where('sender_id', $id);
                        })->latest()->paginate(15);
        $support_id = NULL;
        if(count($messages)>0):
            foreach ($messages as $message ) {
                $support_id = $message->support_id;
                if($message->receiver_id===Auth::guard("admin")->id()){
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
            $image = \App\User::find($id)->profile_photo===NULL? 'assets/user/images/frontEnd/demo.png' :"assets/user/images/user_profile/".\App\Support::find($id)->profile_photo;
        }
        else if($type === "Company"){
            $name = \App\Employer::find($id)->name;
            $image = "assets/employer/profile_images/".(\App\Employer::find($id)->profile_photo ?? "default.png");
        }
        return view("admin.chats.messages")->with([
            "receiver_id" => $id,
            "messages" => $messages,
            "receiver_type" => $type,
            "receiver_image" => $image,
            "status" => $status,
            "support_id" => $support_id,
        ]);
    }
    public function assign(Request $request){
        $this->validate($request,[
            "id" => "required",
            "type" => "required",
            "team_id" => "required",
        ]);
        $supports = Support::where(["sender_id"=>$request->id,"sender_type"=>$request->type,"team_id"=>$request->team_id])->first();
        if($supports === NULL){
            $support = new Support;
            $support->sender_id = $request->id;
            $support->sender_type = $request->type;
            $support->team_id = $request->team_id;
            $support->save();
            $id = $support->id;
        }
        else{
            $supports->status = "Assigned";
            $supports->save();
            $id = $supports->id;
        }
        $messages = Chat::where(["sender_id"=>Auth::guard("admin")->id(),"sender_type"=>"Support","receiver_type"=>$request->type,"receiver_id"=>$request->id])
                        ->orWhere(function($query) use ($request) {
                            $query->where('receiver_id', Auth::guard("admin")->id())
                                ->where('receiver_type', "Support")
                                ->where('sender_type', $request->type)
                                ->where('sender_id', $request->id);
                        })->latest()->paginate(15);
        if(count($messages)>0):
            foreach ($messages as $message ) {
                if($message->receiver_id===Auth::guard("admin")->id() and $message->receiver_type==="Support"){
                    $message->receiver_id = $request->team_id;
                    $message->support_id = $id;
                    $message->save();
                }
                else{
                    $message->sender_id = $request->team_id;
                    $message->support_id = $id;
                    $message->save();
                }
            }
        endif;
        $request->session()->flash('success', "Team member assigned");
        return redirect()->back();
    }
}
