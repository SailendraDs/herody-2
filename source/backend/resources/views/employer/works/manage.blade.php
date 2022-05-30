@extends('layouts.authApp')
@section('title',config('app.name').' | Manage Works')
@section('content')
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12 page-head">
				<div class="section-title text-center mb-4 pb-2">
					<h4 class="title title-line pb-5">Manage Works</h4>
					<p class="text-muted para-desc mx-auto mb-1">Manage All The Works Posted By You</p>
				</div>
			</div>
		</div>
		<div class="row">
			@if($works->count()===0)
			<div class="col-md-12">
				<p>No data Found</p>
			</div>
			@else
			@foreach ($works as $work)
			<div class="col-lg-12 mt-1 pt-2">
				<div class="row">
					<div class="col-lg-12 mt-2 pt-2">
						<div class="job-list-box border rounded bg-light">
							<div class="p-3">
								<div class="row align-items-center">
									<div class="col-lg-9 col-md-9">
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
											@if($work->approved===1)
											<span class="badge badge-success">{{$work->applications->count()}} Application{{$work->applications->count()===1?"":"s"}}</span>
											@else
											<span class="badge badge-danger">Approval Pending</span>
											@endif

											<div class="mt-3 row">
												<div class="col-md-4">
													<form action="{{route("employer.work.delete")}}" method="post">
														@csrf
														<input type="hidden" name="id" value="{{$work->id}}">
														<button type="submit" class="btn btn-danger btn-sm"><i class="fa fa-trash"></i></button>
													</form>
												</div>
												<div class="col-md-4">
													<a href="{{route("employer.work.edit",$work->id)}}" class="btn btn-success btn-sm"><i class="fa fa-edit"></i></a>
												</div>
												@if($work->applications->count()>0)
												<div class="col-md-4">
													<a href="{{route("employer.work.applications",$work->id)}}" class="btn btn-primary btn-sm"><i class="fa fa-eye"></i></a>
												</div>
												@endif
											</div>
										</div>
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
</section>
@endsection