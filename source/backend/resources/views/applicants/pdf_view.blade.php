<?php
    $score = 0;
    if($user->profile_photo!=NULL){
        $score = $score+10;
    }
    if($user->state!=NULL){
        $score = $score+10;
    }
    if($user->about!=NULL){
        $score = $score+10;
    }
    if($exps->count()!=0){
        $score = $score+10;
    }
    if($user->achievements!=NULL){
        $score = $score+10;
    }
    if($user->hobbies!=NULL){
        $score = $score+10;
    }
    if($edus->count()!=0){
        $score = $score+10;
    }
    if($projs->count()!=0){
        $score = $score+10;
    }
    if($skills->count()!=0){
        $score = $score+10;
    }
    if($user->address!=NULL){
        $score = $score+10;
    }
    if($user->hobbies!=NULL){
        $hobbies = explode(',',$user->hobbies);
    }
    if($user->achievements!=NULL){
        $achievements = explode(',',$user->achievements);
    }
?>
@extends('layouts.app')
@section('title',config('app.name').' | '.$user->user_name.' profile')
@section("heads")
<link rel="stylesheet" href="{{asset('assets/applicant/css/style.css')}}">
@endsection
@section('content')
<div class="container mt-3" id="pdf">
    <div class="row">
        <div class="col-lg-4">
        
        <div>Resume Score:
                <div class="progress" style="height:2em">
                    <div class="progress-bar bg-success" role="progressbar" style="width: {{$score}}%;" aria-valuenow="{{$score}}" aria-valuemin="0" aria-valuemax="100">{{$score}}%</div>
                </div>
            </div><br/>
            <div class="user-personal">
            @if(is_null($user->profile_photo))
                <img src="{{asset('assets/user/images/frontEnd/demo.png')}}"
                        width="100" height="100" class="rounded-circle"
                        style="margin: auto;">

            @else
                <img src="{{asset('assets/user/images/user_profile/'.$user->profile_photo)}}"
                        width="100" height="100" class="rounded-circle"
                        style="margin: auto;">
            @endif
            <br/>
            {{$user->name}}
            </div>
            <div class="user-about mt-3">
                About User <br/><br/>
                <div style="word-wrap: break-word;">
                {!! $user->about !!}
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="info">
                <i class="fa fa-book"></i> Education<br/><br/>
                @if($edus->count()==0)
                <p>@lang("No Data Found")</p>
                @else
                <div class="info-block">
                    @foreach($edus as $edu)
                        <div class="info-blocks">
                            <strong>{{$edu->type}}</strong><br/>
                            <p>{{$edu->name}}</p>
                            <p>{{$edu->course}}</p>
                            <p>{{$edu->start}} - {{$edu->end}}</p>
                        </div>
                    @endforeach
                </div>
                @endif
            </div>
            <div class="info mt-2">
                <i class="fa fa-briefcase"></i> Work Experiences<br/><br/>
                
                @if($exps->count()==0)
                <p>@lang("No Data Found")</p>
                @else
                <div class="info-block">
                    @foreach($exps as $exp)
                        <div class="info-blocks">
                            <strong>{{$exp->company}}</strong><br/>
                            <p>{{$exp->designation}}</p>
                            <p>{!!$exp->des!!}</p>
                            <p>{{$exp->start}} - {{$exp->end}}</p>
                        </div>
                    @endforeach
                </div>
                @endif
            </div>
            <div class="info mt-2">
                <i class="fas fa-palette"></i> Projects<br/><br/>
                @if($projs->count()==0)
                <p>@lang("No Data Found")</p>
                @else
                <div class="info-block">
                    @foreach($projs as $proj)
                        <div class="info-blocks">
                            <strong>{{$proj->title}}</strong><br/>
                            <p>{!!$proj->des!!}</p>
                        </div>
                    @endforeach
                </div>
                @endif
            </div>
            <div class="info mt-2">
                <i class="fa fa-sketch"></i> Skills<br/><br/>
                @if($skills->count()==0)
                <p>@lang("No Data Found")</p>
                @else
                <div class="skills">
                    @foreach($skills as $skill)
                        <div class="badge badge-pill badge-info">
                            {{$skill->name}} | {{$skill->rating}}
                        </div>
                    @endforeach
                </div>
                @endif
            </div>
            <div class="info mt-2">
                <i class="fa fa-certificate"></i> Achievements<br/><br/>
                @if($user->achievements==NULL)
                <p>@lang("No Data Found")</p>
                @else
                <div class="skills">
                    @foreach($achievements as $ach)
                        <div class="badge badge-pill badge-info">
                            {{$ach}}
                        </div>
                    @endforeach
                </div>
                @endif
            </div>
            <div class="info mt-2">
                <i class="fas fa-basketball-ball"></i> Interests and Hobbies<br/><br/>
                @if($user->hobbies==NULL)
                <p>@lang("No Data Found")</p>
                @else
                <div class="skills">
                    @foreach($hobbies as $hobby)
                        <div class="badge badge-pill badge-info">
                            {{$hobby}}
                        </div>
                    @endforeach
                </div>
                @endif
            </div>
        </div>
    </div>
</div>
@endsection
@section('scripts')
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.0.272/jspdf.debug.js"></script>


<script>
    window.onload = function() {
        window.print();
    }

 </script>

@endsection