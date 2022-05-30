<?php
    $enc = array();
?>
@extends('layouts.authApp')
@section('title',config('app.name').' | My Chats')
@section('content')
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2 page-head">
					<h4 class="title title-line pb-5">Chats</h4>
                    <a href="{{route("employer.support")}}" class="btn btn-info float-right">Initiate Support</a>
				</div>
			</div>
		</div>
		<div class="row">
            <div class="col-md-12">
                @if($chats->count()===0)
                <div class="col-md-12">
                    <p>No data Found</p>
                </div>
                @else
                <ul class="list-group">
                @foreach ($chats as $message)
                @if(in_array(["id"=>$message->sender_id,"type"=>$message->sender_type],$enc) or in_array(["id"=>$message->receiver_id,"type"=>$message->receiver_type],$enc))
                    <?php continue; ?>
                @else
                <?php 
                    if($message->sender_id==Auth::guard("employer")->id() && $message->sender_type==="Company"){
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
                            <a href="{{route("employer.messages",[$type,$uid])}}" class="text-decoration-none text-truncate" style="color:black;display:block;height:100%;width:100%">
                                {!!$message->message!!}
                            </a>
                            </span>
                            <br/>
                            <span class="fa fa-clock mr-2"></span>{{\Carbon\Carbon::parse($message->created_at)->diffForHumans()}}
                        </span>
                        @if($message->sender_id==Auth::guard("employer")->id() && $message->sender_type==="Company")
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