@extends('layouts.sidebar')
@section('user-details')
<div class="d-flex justify-content-center">
	<img src="@if(Auth::user()->profile_photo==NULL) {{asset('assets/user/images/frontEnd/demo.png')}} @else {{asset('assets/user/images/user_profile/'.Auth::user()->profile_photo)}} @endif" alt="" class="img-fluid rounded-circle"> 
</div>
<div class="text-center text-white mt-2">
	<h6>{{Auth::user()->name}}</h6>
	<p class="text-muted m-0">Worker</p>
</div>
@endsection
@section('navigation')
<li class="{{Request::is('user/dashboard')? 'active':''}}"><a href="{{route('user.dashboard')}}">Dashboard</a></li>
<li class="{{Request::is('user/profile')? 'active':''}}"><a href="{{route('user.profile')}}">Profile</a></li>
<li class="{{Request::is('user/resume')? 'active':''}}"><a href="{{route('user.resume')}}">Resume</a></li>
<li class="{{Request::is('user/works')? 'active':''}}"><a href="{{route('user.works.show')}}">Applied Works</a></li>
<li class="{{Request::is('user/wallet')? 'active':''}}"><a href="{{route('user.wallet')}}">Wallet</a></li>
<li class="{{Request::is('user/chats')? 'active':''}}"><a href="{{route('user.chats')}}">Chats</a></li>
<li class="{{Request::is('user/change-pass')? 'active':''}}"><a href="{{route('user.changePassword')}}">Change Password</a></li>
<li><a href="{{route('user.logout')}}"> Logout</a></li>
@endsection