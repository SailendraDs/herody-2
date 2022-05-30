@extends('layouts.authApp')
@section('title', config('app.name').' | Files')
@section('heads')
@section('content')
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2 page-head">
					<h4 class="title title-line pb-5">Files uploaded by worker {{$work->worker->name}}</h4>
				</div>
			</div>
		</div>
            <div class="row">
                <div class="col-md-12">
                    <div class="job-detail mt-2 p-2">
                        <div class="job-detail-desc">
                          @foreach ($work->work->objectives as $key => $objective)
                          <div class="job-details-desc-item mb-3 bg-white p-2 rounded shadow-sm">
                              <div class="float-left mr-3">
                                  <i class="mdi mdi-send text-primary"></i>
                              </div>
                              <p class="text-muted mb-2">{{$objective->description}}</p>
                              <p>Duration: {{$objective->duration}}</p>
                              @if($objective->price)<p>Price: {{$objective->price}}</p>@endif
                              <p>File: <a href="{{asset("assets/work/files/".$objective->file)}}" target="_blank" class="btn btn-link">Click here to view file</a></p>
                              @if(isset($work->files->{$objective->description}))
                              <p>Uploaded file: <a href="{{asset("assets/user/work/".$work->files->{$objective->description}->file)}}" target="_blank" class="btn btn-link">Click here to view uploded file</a></p>
                              @else
                              <p>User has not uploaded any file for this objective</p>
                              @endif
                          </div>
                          @endforeach
                        </div>
                    </div>
                </div>
            </div>
	</div>
</section>
@endsection