<?php
    $enc = array();
?>
@extends('manager.master')
@section('title','Manager | Messages')
@section('body')

<div class="container-fluid">
    <h2 class="mb-4">My Messages</h2>

    <div class="card mb-4">
        <div class="card-header bg-white font-weight-bold">
            Messages
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-12">
                    @if($status==="Closed" or $status==="Solved")
                    <p>The ticket has been marked {{$status}}</p>
                    @else
                    <form method="POST" action="{{route("manager.sendMessage")}}">
                        @csrf
                        <input type="hidden" name="receiver_id" value="{{$receiver_id}}">
                        <input type="hidden" name="receiver_type" value="{{$receiver_type}}">
                        <input type="hidden" name="support_id" value="{{$support_id}}">
                        <textarea name="message" id="message"></textarea>
                        <button type="submit" class="btn btn-secondary btn-block btn-sm mt-1"><i class="fa fa-share"></i></button>
                    </form>
                    @endif
                    <br>
                    <hr>
                    <div class="messages mt-4">
                        @if(count($messages)==0)
                        <h3 class="text-center">No messages found.</h3>
                        @else
                            <?php $i=0; ?>
                            @foreach($messages as $msg)
                                @if($msg->sender_id==Auth::guard("manager")->id() && $msg->sender_type==="Support")
                                <table class="table" style="@if($i%2!=0) background: #CCCECF; @endif overflow:auto;">
                                    <tr>
                                        <td style="width:6%"><img src="{{asset('assets/main/images/logo-dark.png')}}" class="border border-dark rounded-circle" height="60px" width="60px"></td>
                                        <td>{!!$msg->message!!}</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><i><span class="float-left"><span class="fa fa-check"></span> {{\Carbon\Carbon::parse($msg->created_at)->diffForHumans()}}</span>
                                            <span class="float-right">@if($msg->isseen==1) <span class="fa fa-check-double"></span> {{\Carbon\Carbon::parse($msg->updated_at)->diffForHumans()}} @endif</span></i>
                                        </td>
                                    </tr>
                                </table>
                                @else
                                <table class="table" style="@if($i%2!=0) background: #CCCECF; @endif overflow:auto;" >
                                    <tr>
                                        <td>{!!$msg->message!!}</td>
                                        <td style="width:6%"><img src="{{asset($receiver_image)}}" class="border border-dark rounded-circle" height="60px" width="60px"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><i><span class="float-left"><span class="fa fa-check"></span> {{\Carbon\Carbon::parse($msg->created_at)->diffForHumans()}}</span></i>
                                        </td>
                                    </tr>
                                </table>
                                @endif
                        <?php $i++; ?>
                            @endforeach
                        {{$messages->links()}}
                        @endif
                    </div>
                </div>
            </div>
        </div>
	</div>
</div>
@endsection
@section('scripts')
<script src="https://cdn.ckeditor.com/4.13.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('message');
</script>
@endsection