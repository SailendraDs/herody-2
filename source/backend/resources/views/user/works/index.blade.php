@extends('layouts.authApp')
@section('title',config('app.name').' | My Project')
@section('content')
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2 page-head">
					<h4 class="title title-line pb-3">Manage Works</h4>
					<p class="text-muted para-desc mx-auto mb-1">Manage All The Works Applied By You</p>
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
											<h6 class="mb-2"><a href="{{route("work.details",[$work->work->id,md5($work->work->name)])}}" class="text-dark">{{$work->work->name}}</a></h6>
											<p class="text-muted mb-0"><i class="mdi mdi-bank mr-2"></i>{{$work->work->employer->cname}}</p>
											<ul class="list-inline mb-0">
												<li class="list-inline-item">
													<p class="text-muted mb-0"><i class="mdi mdi-clock-outline mr-2"></i>{{\Carbon\Carbon::parse($work->created_at)->diffForHumans()}}</p>
												</li>
											</ul>
										</div>
									</div>
									<div class="col-lg-3 col-md-3">
										<div class="job-list-button-sm text-right">
											<span class="badge badge-{{$work->status===0?"info":($work->status===1?"primary":($work->status===2?"success":($work->status===3?"danger":($work->status===4?"secondary":""))))}}">{{$work->status===0?"Applied":($work->status===1?"Shortlisted":($work->status===2?"Selected":($work->status===3?"Rejected":($work->status===4?"Paid":"Work Submitted"))))}}</span>
											@if($work->status===2)
											<div class="mt-3">
												<a href="{{route("user.works.work",$work->id)}}" class="btn btn-success btn-sm"><i class="fa fa-edit"></i></a>
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
			@endforeach
			@endif
			{{$works->links()}}
		</div>
	</div>
@endsection