@extends('layouts.authApp')
@section('title',config('app.name').' | ' .$employer->name)
@section('content')
<div class="container">
	<div class="row">
		<div class="col-lg-12">
			<div class="row">
				<div class="col-lg-12 page-head">
					<h4 class="mb30">Dashboard</h4>
				</div>
				<div class="col-sm-6 col-md-6 col-lg-6 col-xl-6">
					<div class="card">
						<div class="card-header">
							<h4 class="card-title">Works</h4>
						</div>
						<div class="card-body">
							<div class="timer">{{$employer->works->count()}}</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
@endsection