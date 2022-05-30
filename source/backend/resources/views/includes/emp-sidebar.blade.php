<?php $employer = \App\Employer::find(Auth::guard("employer")->id()); ?>
@extends('layouts.sidebar')
@section('user-details')
<div class="d-flex justify-content-center">
	<img src="@if($employer->profile_photo==NULL) {{asset('assets/user/images/frontEnd/demo.png')}} @else {{asset('assets/employer/profile_images/'.$employer->profile_photo)}} @endif" alt="" class="img-fluid rounded-circle"> 
</div>
<div class="text-center text-white mt-2">
	<h6>{{$employer->name}}</h6>
	<p class="text-muted m-0">Employer</p>
</div>
@endsection
@section('navigation')
<li class="{{Request::is('company/dashboard')? 'active':''}}"><a href="{{route('employer.dashboard')}}">Dashboard</a></li>
<li class="{{Request::is('company/profile')? 'active':''}}"><a href="{{route('employer.profile')}}">Company Profile</a></li>
<li class="{{Request::is('company/works/post')? 'active':''}}"><a href="{{route('employer.work.post')}}">Post a New Work</a></li>
<li class="{{Request::is('company/works')? 'active':''}}"><a href="{{route('employer.work.manage')}}">Manage Works</a></li>
<li class="{{Request::is('company/wallet')? 'active':''}}"><a href="{{route('employer.wallet')}}">Wallet</a></li>
<li class="{{Request::is('company/chats')? 'active':''}}"><a href="{{route('employer.chats')}}">Chats</a></li>
<li class="{{Request::is('company/change-pass')? 'active':''}}"><a href="{{route('employer.changepass')}}">Change Password</a></li>
<li><a href="{{route('employer.logout')}}"><span class="flaticon-logout"></span> Logout</a></li>
@endsection