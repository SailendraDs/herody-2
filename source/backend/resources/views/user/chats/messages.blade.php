@extends('layouts.authApp')
@section('title',config('app.name').' | Messages')
@section('content')
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2 page-head">
					<h4 class="title title-line pb-5">Messages</h4>
				</div>
			</div>
		</div>
		<div class="row">
            <div class="col-md-12">
                @if($status==="Closed" or $status==="Solved")
                <p>The ticket has been marked {{$status}}</p>
                @else
                <form method="POST" action="{{route("user.sendMessage")}}">
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
                            @if($msg->sender_id==Auth::user()->id && $msg->sender_type==="User")
                            <table class="table" style="@if($i%2!=0) background: #CCCECF; @endif overflow:auto;">
                                <tr>
                                    <td style="width:6%"><img src="@if(Auth::user()->profile_photo==NULL) {{asset('assets/user/images/frontEnd/demo.png')}} @else {{asset('assets/user/images/user_profile/'.Auth::user()->profile_photo)}} @endif" class="border border-dark rounded-circle" height="60px" width="60px"></td>
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
</section>
@endsection
@section('scripts')
<script src="https://cdn.ckeditor.com/4.13.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('message');
</script>
@endsection