@extends('layouts.authApp')
@section('title',config('app.name').' | Work Applications')
@section('content')
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2">
					<h4 class="title title-line pb-5">Manage Work Applications</h4>
				</div>
			</div>
		</div>
		<div class="row">
			@if($applications->count()===0)
			<div class="col-md-12">
				<p>No data Found</p>
			</div>
			@else
			@foreach ($applications as $application)
			<div class="col-lg-4 col-md-6 mt-4 pt-2">
				<div class="card">
					<div class="card-header">
						<span class="badge badge-{{$application->status===0?"info":($application->status===1?"primary":($application->status===2?"success":($application->status===3?"danger":($application->status===4?"secondary":""))))}}">{{$application->status===0?"Applied":($application->status===1?"Shortlisted":($application->status===2?"Selected":($application->status===3?"Rejected":($application->status===4?"Paid":""))))}}</span>
						<a href="{{route("employer.messages",["User",$application->user_id])}}" class="btn btn-success btn-inline ml-4 btn-sm"><i class="fa fa-comment"></i></a>
					</div>
					<div class="card-body">
						<img src="@if($application->worker->profile_photo==NULL) {{asset('assets/user/images/frontEnd/demo.png')}} @else {{asset('assets/user/images/user_profile/'.$application->worker->profile_photo)}} @endif" alt="" class="img-fluid d-block avatar avatar-small rounded-pill" style="margin:auto"/>
						<div class="grid-list-desc mt-3">
							<h5 class="mb-1 text-center"><a href="{{route("applicant.view",$application->worker->id)}}" class="text-dark">{{$application->worker->name}}</a></h5>
							<p class="text-muted f-14 mb-1 text-center">{{$application->worker->email}}</p>
							<div class="apply-button p-3 border-top">
								<div class="row">
									@if($application->status===0)
									<div class="col-md-4">
										<form action="{{route("employer.work.shortlist",$application->work->id)}}" method="post">
											@csrf
											<input type="hidden" name="id" value="{{$application->worker->id}}">
											<button class="btn btn-info btn-sm">Shortlist</button>
										</form>
									</div>
									@endif
									@if($application->status===1)
									<div class="col-md-4">
										<form action="{{route("employer.work.select",$application->work->id)}}" method="post">
											@csrf
											<input type="hidden" name="id" value="{{$application->worker->id}}">
											<button class="btn btn-success btn-sm">Select</button>
										</form>
									</div>
									@endif
									@if($application->status===0 or $application->status===1)
									<div class="col-md-4">
										<form action="{{route("employer.work.reject",$application->work->id)}}" method="post">
											@csrf
											<input type="hidden" name="id" value="{{$application->worker->id}}">
											<button class="btn btn-danger btn-sm">Reject</button>
										</form>
									</div>
									@endif
									<div class="col-md-4">
										<button class="btn btn-primary btn-sm" data-answers="{{$application->answers}}" onclick="viewAns(this)">View Answers</button>
									</div>
									@if($application->files!==NULL)
									<div class="col-md-4">
										<a class="btn btn-secondary btn-sm" href="{{route("employer.work.files",$application->id)}}">View Files</a>
									</div>
									@if($application->status!==4)
									<div class="col-md-4">
										<button class="btn btn-success btn-sm" onclick="acceptWork('{{$application->id}}')">Accept Work</button>
									</div>
									@endif
									@endif
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			@endforeach
			@endif
			{{$applications->links()}}
		</div>
	</div>
</section>

<div class="modal fade" id="answers" tabindex="-1" role="dialog" aria-labelledby="answers">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="answersLabel">Answers</h4>
            </div>
                <div class="modal-body">
                    @foreach (json_decode($application->work->questions) as $key => $question)
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group app-label mt-2">
                                <label class="text-muted">{{$question}}</label>
                                <input type="text" id="ans{{$key}}" required class="form-control resume" placeholder="" disabled>
                            </div>
                        </div>
                    </div>
                    @endforeach
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="accept" tabindex="-1" role="dialog" aria-labelledby="accept">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="acceptLabel">Accept Work</h4>
            </div>
                <div class="modal-body">
                    <form action="{{route("employer.work.accept")}}" method="post">
                        @csrf
						<input type="hidden" id="modalid" name="id">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="amount">Enter amount to pay</label>
                                    <input type="number" class="form-control" name="amount" placeholder="Amount">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <button class="btn btn-primary">Pay</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection
@section('scripts')
	<script>
		function viewAns(obj){
			const ans = $(obj).data("answers");
			ans.map((key,a)=>{
				$(`#ans${a}`).val(key);
			});
			$("#answers").modal("show");
		}
		function acceptWork(id){
			$("#modalid").val(id);
			$("#accept").modal("show");
		}
	</script>
@endsection