<?php
    $states = DB::table('states')->where('country_id','101')->orderBy('name','asc')->get();
?>
@extends('layouts.authApp')
@section('title',config('app.name').' | Profile')
@section("heads")
<style>
#btndp{
    margin: 2em 0 1em 2em;
    border: 1px solid green;
    color: black;
    background: white;
    border-radius: 5px;
    font-size: 1.25em;
    font-weight: bold;
    cursor: pointer;
}
#btndp:hover{
    background: green;
    color: white;
    border-color: black;
}
</style>
@endsection
@section('content')
		<div class="container ml-4">
			<div class="row">
				<div class="col-lg-12">
					<div class="my_profile_form_area">
						<div class="row">
							<div class="col-lg-12 page-head">
								<h4 class="fz20 mb20">My Profile</h4>
							</div>
							<div class="col-lg-12">
								<div class="my_profile_thumb_edit"></div>
                            </div>
                            <form method="POST" action="{{ route('user.profile') }}" enctype="multipart/form-data">
                            @csrf
                            <div class="row">
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <span class="form-control-label" for="name">@lang('Name')</span>
                                    <input type="text" name="name" class="form-control" placeholder="Name" value="{{ $user->name }}" required>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <span class="form-control-label" for="phone">@lang('Phone No')</span>
                                    <input type="tel" name="phone" class="form-control" placeholder="Your phone" value="{{ $user->phone }}" required>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <span class="form-control-label" for="state">@lang('State')</span>
                                    <select name="state" id="states" class="custom-select" value="{{$user->state}}">
                                        @foreach($states as $state)
                                            <option value="{{$state->name}}" @if($user->state==$state->name) selected="selected" @endif>{{$state->name}}</option>
                                        @endforeach
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <span class="form-control-label" for="city">@lang('City')</span>
                                    <select name="city" id="cities" class="custom-select" value="{{$user->state}}">
                                        <option value="{{$user->city}}">{{$user->city}}</option>
                                    </select>
                                </div>
                            </div>

                            <div class="col-lg-6">
                                <div class="form-group">
                                    <span class="form-control-label" for="address">@lang('Address')</span>
                                    <input type="text" name="address" class="form-control"  placeholder="Address" value="{{ $user->address }}" >
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <span class="form-control-label" for="zip_code">@lang('Zip Code')</span>
                                    <input type="text" name="zip_code" class="form-control" placeholder="Zip Code" value="{{ $user->zip_code }}" >
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <span class="form-control-label">@lang('Referal Code')</span>
                                    <input type="text" value="{{ $user->ref_code }}" disabled>
                                    <small class="text-info">Use this code to invite your friends to use the platform, and you will get 5% of your friend's earnings.</small>
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <span class="form-control-label">@lang('About')</span>
                                    <textarea name="about" id="about" value="{{$user->about}}" style="display:none"></textarea>
                                    <div contenteditable="true" class="border border-dark rounded p-1" style="height:7em;width:100%" onkeyup="document.getElementById('about').value=this.innerHTML;">{!!$user->about!!}</div>
                                </div>
                            </div>

                            <div class="col-lg-12">
                                <div class="form-group">
                                    <input type="file" id="dp" name="profile_photo" onchange="getn(this.value)" style="display:none">
                                    <button type="button" id="btndp" class="float-left" onclick="document.getElementById('dp').click();">Upload a profile pic</button><br>
                                    <br>
                                    <br>
                                    <br><br>
                                    <small class="text-info">(@lang('Image will be resized into 224 x 235 px'))</small><br>
                                    <small class="text-info" id="getn"></small>
                                </div>
                            </div>
                            <div class="form-group">
                                <input type="submit" class="btn btn-success" value="Save Changes">
                            </div>
                        </div>
                        </form>
					</div>
				</div>
			</div>
@endsection
@section('scripts')
<script src="{{asset('assets/main/js/world.js')}}"></script>
<script>
function getn(str){
    str = str.split(/(\\|\/)/g).pop();
    $('#getn').html(str);
}
</script>      
@endsection