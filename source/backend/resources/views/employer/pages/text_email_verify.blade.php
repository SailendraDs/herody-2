<?php
    $emp = DB::table('employers')->find(Auth::guard('employer')->id());
    if($emp->email_verified==1){ ?>
    <script>location.href="{{route('employer.dashboard')}}";</script>
    <?php }
?>
@extends('layouts.app')
@section('title',config('app.name').' | Verify Email')

@section('content')
    <div class="block remove-bottom">
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="alert alert-secondary">Your Email is not verified. Kindly <a href="{{route('employer.verify.email')}}">Click here</a> to send an email verification code.</div>
        </div>
    </div>
</div>
</div>
@endsection