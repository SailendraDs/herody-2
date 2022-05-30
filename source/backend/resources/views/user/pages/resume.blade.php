<?php
if($user->hobbies!=NULL){
    $hobbies = explode(',',$user->hobbies);
}
if($user->achievements!=NULL){
    $achievements = explode(',',$user->achievements);
}
?>
@extends('layouts.app')
@section('title',config('app.name').' | '.$user->user_name.' resume')
@section('heads')
<link rel="stylesheet" href="{{asset('assets/applicant/css/style.css')}}">
<link rel="stylesheet" href="{{asset('assets/star/starrr.css')}}">
<style>
    .starrr a{
        font-size: 2em;
    }
    .divd{
      height: 6em;
      background: #E4E4E4;
      width:100%;
      padding:0.2em;
      overflow:auto;
    }
</style>
@endsection
@section('content')

<div class="header pb-6 d-flex align-items-center" style="min-height: 400px; background-size: cover; background-position: center top;">
      <!-- Mask -->
      <span class="mask bg-gradient-default opacity-8"></span>
      <!-- Header container -->
      <div class="container-fluid d-flex align-items-center">
        <div class="row">
          <div class="col-lg-12 col-md-12">
            <h1 class="display-2 text-white">Hello {{$user->name}}</h1>
            <p class="text-white mt-0 mb-5"> Provide your Profile Details to be selected for Internships.! </p>
          </div>
        </div>
      </div>
    </div>
    <!-- Page content -->
    <div class="container-fluid mt--6">
      <div class="row">
        <div class="col-xl-4 order-xl-2">
          <div class="card card-profile">
            <div class="row justify-content-center">
              <div class="col-lg-3 order-lg-2">
                <div class="card-profile-image">
                  <a href="#">
                    <img src="@if($user->profile_photo==NULL) {{asset('assets/user/images/frontEnd/demo.png')}} @else {{asset('assets/user/images/user_profile/'.Auth::user()->profile_photo)}} @endif" class="rounded-circle">
                  </a>
                </div>
              </div>
            </div>
            <div class="card-header text-center border-0 pt-8 pt-md-4 pb-0 pb-md-4">
             
            </div>
            <div class="card-body pt-0">
              <div class="row">
                <div class="col">
                  <div class="card-profile-stats d-flex justify-content-center">
                    <div>
                      <span class="heading">{{$user->works->count()}}</span>
                      <span class="description"><i class="fa fa-paper-plane"></i> Works</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="text-center">
                <h5 class="h3">
                  {{$user->name}}<span class="font-weight-light"></span>
                </h5>
                <div class="h5 font-weight-300">
                  <i class="ni location_pin mr-2"></i>{{$user->city}}, {{$user->state}}
                </div>
                <hr>
                <h3 class="h3 card-title">Resume</h3>
                <div>
                  <a type="button" href="{{route('applicant.view',$user->id)}}" class="btn btn-warning">Web View </a> 
                </div>
                <br>
                <div><a type="button" href="{{route('print.view',$user->id)}}" class="btn btn-success">Download</a></div>
                
              </div>
            </div>
          </div>
          <!-- Progress track -->
       
        </div>
        <div class="col-xl-8 order-xl-1">
          <div class="card">
            <div class="card-header">
              <div class="row align-items-center">
                <div class="col-8">
                  <h3 class="mb-0">Resume </h3>
                </div>
                
              </div>
            </div>
            <div class="card-body">
              <form>
                <h6 class="heading-small text-muted mb-4">Your Resume</h6>
                <div class="pl-lg-4">
                  <div class="row">
                    <div class="col-lg-12">
                        <div class="form-group">
                          <span class="form-control-label">Education Details</span>
                          <button type="button" class="btn btn-primary" data-toggle="modal" style="float: right;" data-target="#eduModal">
                            Add Education
                          </button>
                        </div>
                        <br/>
                    @if($edus->count()==0)
                    <p>@lang("No Data Found")</p>
                    @else
                    <div class="info-block">
                        @foreach($edus as $edu)
                            <div class="info-blocks">
                                <a href="{{route('user.edu-delete',$edu->id)}}" class="float-right"><i class="fa fa-trash" style="color:green"></i></a>
                                <strong>{{$edu->type}}</strong><br/>
                                <p>{{$edu->name}}</p>
                                <p>{{$edu->course}}</p>
                                <p>{{$edu->start}} - {{$edu->end}}</p>
                            </div>
                        @endforeach
                    </div>
                    @endif
                      </div>
                      </div>
                          <hr>
                     <div class="row">
                      <div class="col-lg-12 mt-2 mb-2">
                        <div class="form-group">
                          <span class="form-control-label" for="input-email">Experience Details</span>
                          <button type="button" class="btn btn-primary" data-toggle="modal" style="float: right;" data-target="#expModal">
                            Add Work Experience
                          </button>
                          </div>
                          @if($exps->count()==0)
                    <p>@lang("No Data Found")</p>
                    @else
                    <div class="info-block">
                        @foreach($exps as $exp)
                            <div class="info-blocks">
                                <a href="{{route('user.exp-delete',$exp->id)}}" class="float-right"><i class="fa fa-trash" style="color:green"></i></a>
                                <strong>{{$exp->company}}</strong><br/>
                                <p>{{$exp->designation}}</p>
                                <p>{!!$exp->des!!}</p>
                                <p>{{$exp->start}} - {{$exp->end}}</p>
                            </div>
                        @endforeach
                    </div>
                    @endif
                      </div>
                      </div>
                          <hr>
                  <div class="row">
                    <div class="col-lg-12 mt-2 mb-2">
                      <div class="form-group">
                        <span class="form-control-label">Project Details</span>
                        <button type="button" class="btn btn-primary" data-toggle="modal" style="float: right;" data-target="#projModal">
                            Add Projects
                          </button>
                          </div>
                          @if($projs->count()==0)
                    <p>@lang("No Data Found")</p>
                    @else
                    <div class="info-block">
                        @foreach($projs as $proj)
                            <div class="info-blocks">
                                <a href="{{route('user.proj-delete',$proj->id)}}" class="float-right"><i class="fa fa-trash" style="color:green"></i></a>
                                <strong>{{$proj->title}}</strong><br/>
                                <p>{!!$proj->des!!}</p>
                            </div>
                        @endforeach
                    </div>
                    @endif
                      </div>
                      </div>
                    <hr>
                    <div class="row">
                    <div class="col-lg-12 mt-2 mb-2">
                      <div class="form-group">
                        <span class="form-control-label" for="input-last-name">Skills</span>
                        <button type="button" class="btn btn-primary" data-toggle="modal" style="float: right;" data-target="#skillModal">
                          Add Skills
                        </button>
                        </div>
                        @if($skills->count()==0)
                    <p>@lang("No Data Found")</p>
                    @else
                    <div class="skills">
                        @foreach($skills as $skill)
                            <div class="badge badge-pill badge-info">
                                {{$skill->name}} | {{$skill->rating}} <i class="fa fa-star fa-sm" style="color:#FFD119"></i> &nbsp;<a href="{{route('user.skill-delete',$skill->id)}}"><i class="fa fa-trash fa-sm" style="color:red"></i></a>
                            </div>
                        @endforeach
                    </div>
                    @endif
                      </div>
                      </div>
                  <hr>
                  <div class="row">
                    <div class="col-lg-12 mt-2 mb-2">
                      <div class="form-group">
                        <div class="form-control-label">
                          <span class="form-control-label" for="input-email">Hobbies</span>
                          <button type="button" class="btn btn-primary" data-toggle="modal" style="float: right;" data-target="#hobbyModal">
                            Add Hobbies
                          </button>
                          </div>
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
                   <hr>
                  <div class="row">
                    <div class="col-lg-12 mt-2 mb-2">
                      <div class="form-group">
                        <div class="form-control-label">
                          <span class="form-control-label" for="input-email">Achievements</span>
                          <button type="button" class="btn btn-primary" data-toggle="modal" style="float: right;" data-target="#achModal">
                            Add Achievements
                          </button>
                        </div>
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
                    </div>
                  </div>
                  <hr>
                  
                  <div class="row">
                    <div class="col-lg-12 mt-2 mb-2">
                      <div class="form-group">
                        <div class="form-control-label">
                          <span class="form-control-label" for="input-email">Social Profiles</span>
                          <button type="button" class="btn btn-primary" data-toggle="modal" style="float: right;" data-target="#socialModal">
                            Add Social Profiles
                          </button>
                      </div><br>
                      <div class="row mt-2">
                      @if($user->fb!=NULL)
                      <div class="col-md-12 col-lg-5 mr-2 shadow p-2 border rounded mt-1">
                      <a href="{{$user->fb}}" class="mr-3"><i class="fab fa-facebook fa-2x"></i> {{$user->fb}}</a>
                      </div>
                      @endif
                      @if($user->twitter!=NULL)
                      <div class="col-md-12 col-lg-5 mr-2 shadow p-2 border rounded mt-1">
                      <a href="{{$user->twitter}}" class="mr-3"><i class="fab fa-twitter fa-2x"></i> {{$user->twitter}}</a>
                      </div>
                      @endif
                      @if($user->linkedin!=NULL)
                      <div class="col-md-12 col-lg-5 mr-2 shadow p-2 border rounded mt-1">
                      <a href="{{$user->linkedin}}" class="mr-3"><i class="fab fa-linkedin fa-2x"></i> {{$user->linkedin}}</a>
                      </div>
                      @endif
                      @if($user->github!=NULL)
                      <div class="col-md-12 col-lg-5 mr-2 shadow p-2 border rounded mt-1">
                      <a href="{{$user->github}}" class="mr-3"><i class="fab fa-github fa-2x"></i> {{$user->github}}</a>
                      </div>
                      @endif
                      @if($user->insta!=NULL)
                      <div class="col-md-12 col-lg-5 mr-2 shadow p-2 border rounded mt-1">
                      <a href="{{$user->insta}}" class="mr-3"><i class="fab fa-instagram fa-2x"></i> {{$user->insta}}</a>
                      </div>
                      @endif
                      </div>
                    </div>
                  </div>
                </div>
                <hr>
                </form></div>
                </div>
                </div>


                </div>
                </div>

                
<!-- Modal Section -->

    <!-- Education Modal -->

    <div class="modal fade" id="eduModal" tabindex="-1" role="dialog" aria-labelledby="eduModal" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title">@lang('Add Education Details')</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <form action="{{route('user.edu-update')}}" method="POST">
            @csrf
                <div class="input-group mb-2">
                    <label for="type" style="display:block">@lang('Institute Type')</label>
                    <select name="type" id="type" class="custom-select">
                        <option value="School">School</option>
                        <option value="High School">High School</option>
                        <option value="Degree">Degree</option>
                        <option value="Post Graduation">Post Graduation</option>
                        <option value="Diploma">Diploma</option>
                        <option value="Ph.D">Ph.D</option>
                        <option value="Certification">Certification</option>
                    </select>
                </div>
                <div class="input-group mb-2">
                    <label for="name">@lang('Institute Name')</label>
                    <input name="name" class="form-control" type="text" placeholder="@lang('Institute Name')">
                </div>
                <div class="input-group mb-2">
                    <label for="course">@lang('Course Name')</label>
                    <input name="course" class="form-control" type="text" placeholder="@lang('Course Name')">
                </div>
                <div class="input-group mb-2">
                    <label for="start">@lang('Start Year')</label>
                    <input name="start" class="form-control" type="text" placeholder="@lang('Start Year')">
                </div>
                <div class="input-group mb-2">
                <label><input style="height:1em" class="form-control" type="checkbox" onchange="document.getElementById('end').value='Currently Here'">
                    @lang('Currently here')</label>
                </div>
                
                <div class="input-group mb-2">
                    <label for="end">@lang('End Year')</label>
                    <input name="end" class="form-control" type="text" placeholder="@lang('End Year')" id="end">
                </div>
                <button class="btn btn-success">Add</button>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
        </div>
    </div>
    </div>

<!-- Experience Modal -->

<div class="modal fade" id="expModal" tabindex="-1" role="dialog" aria-labelledby="expModal" aria-hidden="true">
<div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">@lang('Add Experience Details')</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="modal-body">
        <form action="{{route('user.exp-update')}}" method="POST">
        @csrf
            <div class="input-group mb-2">
                <label for="company">@lang('Organization')</label>
                <input name="company" class="form-control" type="text" placeholder="@lang('Organization')">
            </div>
            <div class="input-group mb-2">
                <label for="designation">@lang('Designation')</label>
                <input name="designation" class="form-control" type="text" placeholder="@lang('Designation')">
            </div>
            <div class="input-group mb-2">
                <label for="des">@lang('Description')</label>
                <textarea name="des" id="des" style="display:none"></textarea>
                <div contenteditable="true" class="divd" onkeyup="document.getElementById('des').value=this.innerHTML"></div>
            </div>
            <div class="input-group mb-2">
                <label for="start">@lang('Start Year')</label>
                <input name="start" class="form-control" type="text" placeholder="@lang('Start Year')">
            </div>
                <div class="input-group mb-2">
                <label><input style="height:1em" type="checkbox" onchange="document.getElementById('endw').value='Currently Here'">
                    @lang('Currently here')</label>
                </div>
            <div class="input-group mb-2">
                <label for="end">@lang('End Year')</label>
                <input name="end" type="text" class="form-control" placeholder="@lang('End Year')" id="endw">
            </div>
            <button class="btn btn-success">Add</button>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>

<!-- Project Modal -->

<div class="modal fade" id="projModal" tabindex="-1" role="dialog" aria-labelledby="projModal" aria-hidden="true">
<div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">@lang('Add Project Details')</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="modal-body">
        <form action="{{route('user.proj-update')}}" method="POST">
        @csrf
            <div class="input-group mb-2">
                <label for="title">@lang('Title')</label>
                <input name="title" class="form-control" type="text" placeholder="@lang('Title')">
            </div>
            <div class="input-group mb-2">
                <label for="projdes">@lang('Description')</label>
                <textarea name="projdes" id="projdes" style="display:none"></textarea>
                <div contenteditable="true" class="divd" onkeyup="document.getElementById('projdes').value=this.innerHTML"></div>
            </div>
            <button class="btn btn-success">Add</button>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>

<!-- Skill Modal -->

<div class="modal fade" id="skillModal" tabindex="-1" role="dialog" aria-labelledby="skillModal" aria-hidden="true">
<div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">@lang('Add Your Skill')</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="modal-body">
        <form action="{{route('user.skill-update')}}" method="POST">
        @csrf
            <div class="input-group mb-2">
                <label for="name">@lang('Skill')</label>
                <input name="name" class="form-control" type="text" placeholder="@lang('Skill')">
            </div>
            <div class="input-group mb-2">
                <label for="rating">@lang('Rating')</label> &nbsp;&nbsp;&nbsp;&nbsp;
                <input name="rating" type="text" class="rating" placeholder="@lang('rate')" hidden>

                <div class="starrr"></div>
            </div>
            <button class="btn btn-success">Add</button>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>

<!-- Hobbies Modal -->
<div class="modal fade" id="hobbyModal" tabindex="-1" role="dialog" aria-labelledby="hobbyModal" aria-hidden="true">
<div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">@lang('Add Your Hobbies')</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="modal-body">
        <form action="{{route('user.hobby-update')}}" method="POST">
        @csrf
            <div class="input-group mb-2">
                <label for="name">@lang('Hobbies')</label>
                <input name="hobby" class="form-control" type="text" placeholder="@lang('Hobbies')" value="{{$user->hobbies}}">
            </div>
            <button class="btn btn-success">Add</button>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>

<!-- Achievement Modal -->
<div class="modal fade" id="achModal" tabindex="-1" role="dialog" aria-labelledby="achModal" aria-hidden="true">
<div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">@lang('Add Your Achievements')</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="modal-body">
        <form action="{{route('user.ach-update')}}" method="POST">
        @csrf
            <div class="input-group mb-2">
                <label for="name">@lang('Achievements')</label>
                <input name="ach" class="form-control" type="text" placeholder="@lang('Achievements')" value="{{$user->achievements}}">
            </div>
            <button class="btn btn-success">Add</button>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>

<!-- Social Modal -->
<div class="modal fade" id="socialModal" tabindex="-1" role="dialog" aria-labelledby="socialModal" aria-hidden="true">
<div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">@lang('Add Social Networks')</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="modal-body">
        <form action="{{route('user.social-update')}}" method="POST">
        @csrf
            <div class="input-group mb-2">
                <label for="fb"><i class="fab fa-facebook"></i>@lang('Facebook')</label>
                <input name="fb" class="form-control" type="text" placeholder="@lang('Facebook')" value="{{$user->fb}}">
            </div>
            <div class="input-group mb-2">
                <label for="twitter"><i class="fab fa-twitter"></i>@lang('Twitter')</label>
                <input name="twitter" class="form-control" type="text" placeholder="@lang('Twitter')" value="{{$user->twitter}}">
            </div>
            <div class="input-group mb-2">
                <label for="linkedin"><i class="fab fa-linkedin"></i>@lang('LinkedIn')</label>
                <input name="linkedin" class="form-control" type="text" placeholder="@lang('LinkedIn')" value="{{$user->linkedin}}">
            </div>
            <div class="input-group mb-2">
                <label for="github"><i class="fab fa-github"></i>@lang('GitHub')</label>
                <input name="github" class="form-control" type="text" placeholder="@lang('GitHub')" value="{{$user->github}}">
            </div>
            <div class="input-group mb-2">
                <label for="insta"><i class="fab fa-instagram"></i>@lang('Instagram')</label>
                <input name="insta" class="form-control" type="text" placeholder="@lang('Instagram')" value="{{$user->insta}}">
            </div>
            <button class="btn btn-success">Add</button>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>
@endsection
@section('scripts')

<script src="{{asset('assets/star/starrr.js')}}"></script>
<script>
    $('.starrr').starrr({
      rating: 5,
      emptyClass: 'far fa-star',
      fullClass: 'fas fa-star',
      change: function(e, value){
          $(".rating").val(value);
      }
    });
</script>
@endsection