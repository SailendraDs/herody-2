@extends('layouts.authApp')
@section('title',config('app.name').' | Edit Work')
@section('content')
<section class="section mt-2">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-10">
				<div class="rounded shadow bg-white p-4">
					<div class="custom-form">
						<div id="message3"></div>
						<form method="post" enctype="multipart/form-data" action="{{route("employer.work.edit",$work->id)}}" name="contact-form" id="contact-form3">
							<h4 class="text-dark mb-3">Edit Work :</h4>
							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Name</label>
										<input id="name" name="name" type="text" class="form-control resume" value="{{$work->name}}" placeholder="">
									</div>
								</div>
							</div>
							@csrf
							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Duration</label>
										<input id="duration" name="duration" type="text" class="form-control resume" value="{{$work->duration}}" placeholder="Ex: 1 week">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Type</label>
										<input name="type" type="text" class="form-control resume" value="{{$work->type}}" placeholder="">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Category</label>
										<div class="form-button">
											<select name="category" value="{{$work->category}}" class="custom-select rounded">
												<option>Category</option>
												@foreach ($cats as $cat)
													<option value="{{$cat}}" @if($work->category===$cat) selected @endif>{{$cat}}</option>
												@endforeach
											</select>
										</div>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Description</label>
										<textarea id="description" name="description" placeholder="">{{$work->description}}</textarea>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">About Work</label>
										<textarea id="about" name="about" placeholder="">{{$work->about}}</textarea>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<div class="custom-control custom-radio custom-control-block">
										<div class="form-group">
											<input type="radio" id="comment1" value="whole" @if($work->comment==="whole") checked @endif name="comment" class="custom-control-input">
											<label class="custom-control-label" for="comment1">Upload files at the completion of whole work</label>
										</div>
									</div>
									<div class="custom-control custom-radio custom-control-block">
										<div class="form-group">
											<input type="radio" id="comment2" value="objective" @if($work->comment==="objective") checked @endif name="comment" class="custom-control-input">
											<label class="custom-control-label" for="comment2">Upload file for every objective completed</label>
										</div>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Pricing Type</label>
										<div class="form-button">
											<select name="pricing" onchange="checkPricing();" id="pricing" class="custom-select rounded">
												<option>Pricing</option>
												<option value="Objective Wise" @if($work->pricing==="Objective Wise") selected @endif>Objective Wise</option>
												<option value="Full Work" @if($work->pricing==="Full Work") selected @endif>Full Work</option>
											</select>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Price</label>
										<input id="price" value="{{$work->price}}" type="number" name="price" class="form-control resume" placeholder="">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Last Date To Apply</label>
										<input type="date" value="{{$work->last_apply}}" name="last_apply" class="form-control resume" placeholder="">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Last Date To Complete</label>
										<input type="date" value="{{$work->last_complete}}" name="last_complete" required class="form-control resume" placeholder="">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Number of candidates required</label>
										<input type="number" value="{{$work->candidates}}" onblur="if(this.value<1){this.value=1} this.value=parseInt(this.value)" name="candidates" min="1" step="1" required class="form-control resume" placeholder="">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-lg-12 mt-2">
									<button class="btn btn-primary">Edit Work</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
@endsection

@section('scripts')
<script src="https://cdn.ckeditor.com/4.13.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('description');
    CKEDITOR.replace('about');
</script>
@endsection