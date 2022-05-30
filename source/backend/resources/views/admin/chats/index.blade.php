<?php
    $enc = array();
?>
@extends('admin.master')
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
                    if($message->sender_id==Auth::guard("admin")->id() && $message->sender_type==="Support"){
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
                            <a href="{{route("admin.messages",[$type,$uid])}}" class="text-decoration-none text-truncate" style="color:black;display:block;height:100%;width:100%">
                                {!!$message->message!!}
                            </a>
                            </span>
                            <br/>
                            <span class="fa fa-clock mr-2"></span>{{\Carbon\Carbon::parse($message->created_at)->diffForHumans()}}
                            <button class="btn btn-secondary ml-4" data-id="{{$uid}}" data-type="{{$type}}" onclick="assignTeam(this)">Assign Team Member</button>
                        </span>
                        @if($message->sender_id==Auth::guard("admin")->id() && $message->sender_type==="Support")
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
<!-- JOB LIST START -->
<div class="modal fade" id="teamModal" tabindex="-1" aria-labelledby="teamModalLabel" aria-hidden="true">
    <div class="modal-dialog mw-100 w-75 modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="teamModalLabel">Assign a team member</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            @if(count($teams)===0)
            <p>You have not added any team member yet. <a href="{{route("admin.teams")}}">Click here</a> to add one.</p>
            @else
            <form action="{{route("admin.chats.assign")}}" method="post">
                @csrf
                <input type="hidden" name="id" id="assign_id">
                <input type="hidden" name="type" id="assign_type">
                <div class="input-group mb-3 row">
                    <label for="team" class="col-md-2">Select a team member</label>
                    <select name="team_id" id="team_id" class="custom-select">
                        <option value="">Select a member</option>
                        @foreach($teams as $team)
                        <option value="{{$team->id}}">{{$team->name}}</option>
                        @endforeach
                    </select>
                </div>
                <button class="btn btn-submit" type="submit">Assign</button>
            </form>
            @endif
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</div>
@endsection
@section('scripts')
<script>
    function assignTeam(obj){
        const id = $(obj).data("id");
        const type = $(obj).data("type");
        const a = confirm("You may not be able to access the chat, if you assign a team member for it.");
        if(a){
            $("#assign_id").val(id);
            $("#assign_type").val(type);
            $("#teamModal").modal("show");
        }
    }
</script>
@endsection