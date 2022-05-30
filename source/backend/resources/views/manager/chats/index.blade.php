<?php
    $enc = array();
?>
@extends('manager.master')
@section('title','Admin | Chats')
@section('body')

<div class="container-fluid">
    <h2 class="mb-4">My Chats</h2>

    <div class="card mb-4">
        <div class="card-header bg-white font-weight-bold">
            Chats
        </div>
        <div class="card-body">
            @if(count($chats)==0)
                <h2 class="text-center">@lang('No Data Available')</h2>
            @else
                <ul class="list-group">
                @foreach ($chats as $message)
                @if(in_array(["id"=>$message->sender_id,"type"=>$message->sender_type],$enc) or in_array(["id"=>$message->receiver_id,"type"=>$message->receiver_type],$enc))
                    <?php continue; ?>
                @else
                <?php 
                    if($message->sender_id==Auth::guard("manager")->id() && $message->sender_type==="Support"){
                        array_push($enc,["id"=>$message->receiver_id,"type"=>$message->receiver_type]);
                        $uid = $message->receiver_id;
                        $type = $message->receiver_type;
                    }
                    else{
                        array_push($enc,["id"=>$message->sender_id,"type"=>$message->sender_type]);
                        $uid = $message->sender_id;
                        $type = $message->sender_type;
                    }
                    if($type === "Support"){
                        $name = "Support";
                        $image = "assets/main/images/logo-dark.png";
                    }
                    else if($type === "User"){
                        $name = \App\User::find($uid)->name;
                        $image = \App\User::find($uid)->profile_photo===NULL? 'assets/user/images/frontEnd/demo.png' :"assets/user/images/user_profile/".\App\User::find($id)->profile_photo;
                    }
                    else if($type === "Company"){
                        $name = \App\Employer::find($uid)->name;
                        $image = "assets/employer/profile_images/".(\App\Employer::find($uid)->profile_photo ?? "default.png");
                    }
                ?>
                    <li class="list-group-item">
                        <img src="{{asset($image)}}" height="40px" width="40px" class="border border-dark rounded-circle" />
                        <span class="font-weight-bold">{{$name}}</span><span class="badge badge-info ml-2">{{$type}}</span>
                        <br/>
                        <span class="float-left">
                            <span class="mt-2" style="margin-left:3em;height:3.5em;width:70%">
                            <a href="{{route("manager.messages",[$type,$uid])}}" class="text-decoration-none text-truncate" style="color:black;display:block;height:100%;width:100%">
                                {!!$message->message!!}
                            </a>
                            </span>
                            <br/>
                            <span class="fa fa-clock mr-2"></span>{{\Carbon\Carbon::parse($message->created_at)->diffForHumans()}}
                            @if(\App\Support::find($message->support_id)->status==="Closed" or \App\Support::find($message->support_id)->status==="Solved")
                            <span>The ticked is {{\App\Support::find($message->support_id)->status}}</span>
                            @else
                            <form action="{{route("manager.chats.close")}}" method="post">
                                @csrf
                                <input type="hidden" name="id" value="{{$message->support_id}}">
                                <button class="btn btn-danger mt-2 btn-inline d-inline" type="submit">Mark as closed</button>
                            </form>
                            <form action="{{route("manager.chats.solve")}}" method="post">
                                @csrf
                                <input type="hidden" name="id" value="{{$message->support_id}}">
                                <button class="btn btn-success mt-2 btn-inline d-inline" type="submit">Mark as solved</button>
                            </form>
                            @endif
                        </span>
                        @if($message->sender_id==Auth::guard("manager")->id() && $message->sender_type==="Support")
                        <span class="float-right">
                            @if($message->isseen==0)
                            <span class="fa fa-check"></span>
                            @else
                            <span class="fa fa-check-double"></span>
                            @endif
                        </span>
                        @endif
                    </li>
                    @endif
                @endforeach
                </ul>
                @endif
            </div>
		</div>
	</div>
</section>
@endsection