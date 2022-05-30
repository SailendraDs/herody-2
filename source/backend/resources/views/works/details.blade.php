@extends('layouts.app')
@section('title', config('app.name').' | '.$work->name)
@section('content')
<!-- JOB DETAILS START -->
<section >
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <h4 class="text-dark mb-3">{{$work->name}}</h4>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8 col-md-7">
                <div class="job-detail border rounded p-4">
                    <div class="job-detail-content">
                        <img src="images/featured-job/img-4.png" alt="" class="img-fluid float-left mr-md-3 mr-2 mx-auto d-block">
                        <div class="job-detail-com-desc overflow-hidden d-block">
                            <h4 class="mb-2"><a href="#" class="text-dark">{{$work->name}}</a></h4>
                            <p class="text-muted mb-0"><i class="mdi mdi-link-variant mr-2"></i>{{$work->employer->cname}}</p>
                        </div>
                    </div>

                    <div class="job-detail-desc mt-4">
                      {!!$work->about!!}
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <h5 class="text-dark mt-4">Job Description :</h5>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="job-detail border rounded mt-2 p-4">
                            <div class="job-detail-desc">
                              {!!$work->description!!}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <h5 class="text-dark mt-4">Objectives :</h5>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="job-detail border rounded mt-2 p-4">
                            <div class="job-detail-desc">
                              @foreach ($work->objectives as $objective)
                              <div class="job-details-desc-item">
                                  <div class="float-left mr-3">
                                      <i class="mdi mdi-send text-primary"></i>
                                  </div>
                                  <p class="text-muted mb-2">{{$objective->description}}</p>
                                  <p>Duration: {{$objective->duration}}</p>
                                  @if($objective->price)<p>Price: {{$objective->price}}</p>@endif
                                  <p>File: <a href="{{asset("assets/work/files/".$objective->file)}}" target="_blank" class="btn btn-link">Click here to view file</a></p>
                              </div>
                              @endforeach
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <h5 class="text-dark mt-4">Primary Responsibilities :</h5>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="job-detail border rounded mt-2 p-4">
                            <div class="job-detail-desc">
                              @foreach($work->responsibilities as $responsibility)
                                <div class="job-details-desc-item">
                                    <div class="float-left mr-3">
                                        <i class="mdi mdi-send text-primary"></i>
                                    </div>
                                    <p class="text-muted mb-2">{{$responsibility}}</p>
                                </div>
                              @endforeach
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 col-md-5 mt-4 mt-sm-0">
                <div class="job-detail border rounded mt-4 p-4">
                    <h5 class="text-muted text-center pb-2"><i class="mdi mdi-information-outline mr-2"></i>Other Information</h5>

                    <div class="job-detail-time border-top pt-4">
                        <ul class="list-inline mb-0">
                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Pricing</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{$work->pricing}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Duration</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{$work->duration}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Category</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{$work->category}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Type</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{$work->type}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Price</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">INR {{$work->price}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Number of candidates required</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{$work->candidates}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Last date to apply</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{\Carbon\Carbon::parse($work->last_apply)->format("d M Y")}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted border-bottom pb-3">
                                <div class="float-left">Last date to complete</div>
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{\Carbon\Carbon::parse($work->last_complete)->format("d M Y")}}</h6>
                                </div>
                            </li>

                            <li class="clearfix text-muted pb-3">
                                <div class="float-right">
                                    <h6 class="f-13 mb-0">{{$work->comment==="whole"?"Upload proofs after completing the whole work":"Upload proofs after completing a particular objective"}}</h6>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="job-detail border rounded mt-4">
                  @if(Auth::check())
                    @if($work->applications->where("user_id",Auth::user()->id)->first()===NULL)
                        <button data-toggle="modal" data-target="#answers" class="btn btn-primary btn-block">Apply for the work</button>
                    @else
                      <a href="" class="btn btn-primary btn-block">You have already applied for the work</a>
                    @endif
                  @else
                    <a href="{{route("login")}}" class="btn btn-primary btn-block">Login to apply for this work</a>
                  @endif
              </div>
            </div>
        </div>
    </div>
</section>
<!-- JOB DETAILS END -->


<div class="modal fade" id="answers" tabindex="-1" role="dialog" aria-labelledby="answers">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="answersLabel">Answers these questions</h4>
            </div>
            <form action="{{route("work.apply")}}" method="post">
                @csrf
                <input type="hidden" name="id" value="{{$work->id}}">
                <div class="modal-body">
                    @foreach ($work->questions as $question)
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group app-label mt-2">
                                <label class="text-muted">{{$question}}</label>
                                <input type="text" name="answers[]" required class="form-control resume" placeholder="">
                            </div>
                        </div>
                    </div>
                    @endforeach
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Apply</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection