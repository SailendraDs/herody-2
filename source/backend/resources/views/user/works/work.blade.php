@extends('layouts.authApp')
@section('title', config('app.name').' | Work')
@section('heads')
<style>
#stopwatch {
    font-size: 80px;
    text-align: center;
}
#buttons{
    margin-top:30px;
}
#buttons li {
    display: inline;
    padding-left: 100px;
}
</style>
@endsection
@section('content')
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2 page-head">
					<h4 class="title title-line pb-5">Complete your work</h4>
				</div>
			</div>
		</div>
		

		<div class="row">
			<div class="col-lg-12">
				<div class="row d-flex justify-content-center">
                    <div class="col-md-6">
                        <div id="stopwatch">
                            00:00:00
                        </div>

                        <ul id="buttons" class="ml-4">
                            <li><button class="btn btn-primary" id="start" onclick="startTimer()">Start</button></li>
                
                            <li><button class="btn btn-info" onclick="resetTimer()">Reset</button></li>
                        </ul>
                    </div>
				</div>
            @if($work->work->comment === "whole")
            <div class="row">
                <div class="col-md-12">
                    <div class="job-detail mt-2 p-2">
                        <div class="job-detail-desc">
                            <form action="{{route("user.works.work.whole",$work->id)}}" enctype="multipart/form-data" method="POST">
                                @csrf
                                @foreach ($work->work->objectives as $objective)
                                <div class="job-details-desc-item mb-3 bg-light p-2 rounded">
                                    <div class="float-left mr-3">
                                        <i class="mdi mdi-send text-primary"></i>
                                    </div>
                                    <p class="text-muted mb-2">{{$objective->description}}</p>
                                    <p>Duration: {{$objective->duration}}</p>
                                    @if($objective->price)<p>Price: {{$objective->price}}</p>@endif
                                    <p>File: <a href="{{asset("assets/work/files/".$objective->file)}}" target="_blank" class="btn btn-link">Click here to view file</a></p>
                                    @if(!isset($work->files->{$objective->description}))
                                    <input type="hidden" name="obj_id[]" value="{{$objective->description}}">
                                    <ul class="list-inline mb-0">
                                        <li class="list-inline-item">
                                            <div class="input-group mt-2 mb-2">
                                                <div class="custom-file">
                                                    <input type="file" name="obj_file[]" class="custom-file-input" required>
                                                    <label class="custom-file-label rounded"><i class="mdi mdi-cloud-upload mr-1"></i> Upload File</label>
                                                </div>
                                            </div>
                                        </li>
                                        <li class="list-inline-item">
                                            <h6 class="text-muted mb-0">Upload Images, Videos Or Documents.</h6>
                                        </li>
                                    </ul>
                                    @else
                                    <p>Uploaded file: <a href="{{asset("assets/user/work/".$work->files->{$objective->description}->file)}}" target="_blank" class="btn btn-link">Click here to view uploaded file</a></p>
                                    @endif
                                </div>
                                @endforeach
                                @if($work->files===NULL)
                                <div class="row">
                                    <div class="col-md-12">
                                        <button class="btn btn-success">Submit</button>
                                    </div>
                                </div>
                                @endif
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            @else
            <div class="row">
                <div class="col-md-12">
                    <div class="job-detail mt-2 p-2">
                        <div class="job-detail-desc">
                          @foreach ($work->work->objectives as $key => $objective)
                          <div class="job-details-desc-item mb-3 bg-light p-2 rounded">
                              <div class="float-left mr-3">
                                  <i class="mdi mdi-send text-primary"></i>
                              </div>
                              <p class="text-muted mb-2">{{$objective->description}}</p>
                              <p>Duration: {{$objective->duration}}</p>
                              @if($objective->price)<p>Price: {{$objective->price}}</p>@endif
                              <p>File: <a href="{{asset("assets/work/files/".$objective->file)}}" target="_blank" class="btn btn-link">Click here to view file</a></p>
                              @if(!isset($work->files->{$objective->description}))
                              <form action="{{route("user.works.work.objective",$work->id)}}" enctype="multipart/form-data" method="post" id="form{{$key}}">
                                @csrf
                                <input type="hidden" name="obj_id" value="{{$objective->description}}">
                                <ul class="list-inline mb-0">
                                    <li class="list-inline-item">
                                        <div class="input-group mt-2 mb-2">
                                            <div class="custom-file">
                                                <input type="file" onchange="document.getElementById('form{{$key}}').submit()" name="obj_file" class="custom-file-input" required>
                                                <label class="custom-file-label rounded"><i class="mdi mdi-cloud-upload mr-1"></i> Upload File</label>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="list-inline-item">
                                        <h6 class="text-muted mb-0">Upload Images, Videos Or Documents.</h6>
                                    </li>
                                </ul>
                              </form>
                              @else
                              <p>Uploaded file: <a href="{{asset("assets/user/work/".$work->files->{$objective->description}->file)}}" target="_blank" class="btn btn-link">Click here to view uploded file</a></p>
                              @endif
                          </div>
                          @endforeach
                        </div>
                    </div>
                </div>
            </div>
            @endif
        </div>
		</div>
	</div>
</section>
@endsection
@section('scripts')
<script>
    document.addEventListener('contextmenu', event => event.preventDefault());
    $(window).on('keydown',function(event)
    {
    if(event.keyCode==123)
    {
        return false;
    }
    else if(event.ctrlKey && event.shiftKey && event.keyCode==73)
    {
        return false;  //Prevent from ctrl+shift+i
    }
    else if(event.ctrlKey && event.keyCode==73)
    {
        return false;  //Prevent from ctrl+shift+i
    }
});
</script>
<script>
    const timer = document.getElementById('stopwatch');

var hr = 0;
var min = 0;
var sec = 0;
var stoptime = true;

function startTimer() {
  if (stoptime == true) {
        stoptime = false;
        $("#start").html("Stop")
        timerCycle();
    }
    else{
        stoptime = true;
        $("#start").html("Start")
    }
}

function timerCycle() {
    if (stoptime == false) {
    sec = parseInt(sec);
    min = parseInt(min);
    hr = parseInt(hr);

    sec = sec + 1;

    if (sec == 60) {
      min = min + 1;
      sec = 0;
    }
    if (min == 60) {
      hr = hr + 1;
      min = 0;
      sec = 0;
    }

    if (sec < 10 || sec == 0) {
      sec = '0' + sec;
    }
    if (min < 10 || min == 0) {
      min = '0' + min;
    }
    if (hr < 10 || hr == 0) {
      hr = '0' + hr;
    }

    timer.innerHTML = hr + ':' + min + ':' + sec;

    setTimeout("timerCycle()", 1000);
  }
}

function resetTimer() {
    hr = 0;
    min = 0;
    sec = 0;
    timer.innerHTML = '00:00:00';
}
</script>
@endsection