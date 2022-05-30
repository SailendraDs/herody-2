@extends('layouts.app')
@section('title', config('app.name').' | Works')
@section('content')
<!-- JOB LIST START -->
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2">
					<h4 class="title title-line pb-5">Available works for you</h4>
				</div>
			</div>
		</div>
		<div class="container">
			<div class="home-form-position">
				<div class="row justify-content-center">
					<div class="col-lg-10">
						<div class="home-registration-form job-list-reg-form bg-light shadow p-4 mb-3">
							<form class="registration-form" method="POST" action="{{route("work.cat")}}">
								@csrf
								<div class="row">
									<div class="col-lg-9 col-md-9">
										<div class="registration-form-box">
											<i class="fa fa-list-alt"></i>
											<select id="select-category" name="cat" class="demo-default">
												<option value="">Categories...</option>
												@foreach ($cats as $cat)
													<option value="{{$cat}}">{{$cat}}</option>
												@endforeach
											</select>
										</div>
									</div>
									<div class="col-lg-3 col-md-6">
										<div class="registration-form-box">
											<input type="submit" id="submit" name="send" class="submitBnt btn btn-primary btn-block" value="Submit">
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		

		<div class="row">
			<div class="col-lg-12">
				<div class="row">
					@if($works->count()===0)
					<div class="col-md-12">
						<p>No Work Found</p>
					</div>
					@else
					@foreach($works as $work)
					<div class="col-lg-12 pt-2">
						<div class="job-list-box border rounded">
							<div class="p-3">
								<div class="row align-items-center">
									<div class="col-lg-2">
										<div class="company-logo-img">
											<img src="{{("assets/employer/profile_images/".$work->employer->profile_photo)}}" alt="" class="img-fluid mx-auto d-block">
										</div>
									</div>
									<div class="col-lg-7 col-md-9">
										<div class="job-list-desc">
											<h6 class="mb-2"><a href="{{route("work.details",[$work->id,md5($work->name)])}}" class="text-dark">{{$work->name}}</a></h6>
											<p class="text-muted mb-0"><i class="mdi mdi-bank mr-2"></i>{{$work->employer->cname}}</p>
											<ul class="list-inline mb-0">
												<li class="list-inline-item">
													<p class="text-muted mb-0"><i class="mdi mdi-clock-outline mr-2"></i>{{\Carbon\Carbon::parse($work->created_at)->diffForHumans()}}</p>
												</li>
											</ul>
										</div>
									</div>
									<div class="col-lg-3 col-md-3">
										<div class="job-list-button-sm text-right">
											<span class="badge badge-success">{{$work->pricing}}</span>

											<div class="mt-3">
												<a href="{{route("work.details",[$work->id,md5($work->name)])}}" class="btn btn-sm btn-primary">Apply</a>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					@endforeach
					@endif
					{{$works->links()}}
				</div>
			</div>
		</div>
	</div>
</section>
<!-- JOB LIST START -->
@endsection