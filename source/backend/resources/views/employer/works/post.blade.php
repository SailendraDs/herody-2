@extends('layouts.authApp')
@section('title',config('app.name').' | Post a Work')
@section('content')
<!-- POST A JOB START -->
<section class="section mt-2">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-10">
				<div class="rounded shadow bg-white p-4">
					<div class="custom-form">
						<div id="message3"></div>
						<form method="post" enctype="multipart/form-data" action="{{route("employer.work.post")}}" name="contact-form" id="contact-form3">
							<h4 class="text-dark mb-3">Post a New Work :</h4>
							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Name</label>
										<input id="name" name="name" type="text" class="form-control resume" placeholder="">
									</div>
								</div>
							</div>
							@csrf
							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Duration</label>
										<input id="duration" name="duration" type="text" class="form-control resume" placeholder="Ex: 1 week">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Type</label>
										<input name="type" type="text" class="form-control resume" placeholder="">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Work Category</label>
										<div class="form-button">
											<select name="category" class="custom-select rounded">
												<option>Category</option>
												@foreach ($cats as $cat)
													<option value="{{$cat}}">{{$cat}}</option>
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
										<textarea id="description" name="description" placeholder=""></textarea>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">About Work</label>
										<textarea id="about" name="about" placeholder=""></textarea>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<div class="custom-control custom-radio custom-control-block">
										<div class="form-group">
											<input type="radio" id="comment1" value="whole" name="comment" class="custom-control-input">
											<label class="custom-control-label" for="comment1">Upload files at the completion of whole work</label>
										</div>
									</div>
									<div class="custom-control custom-radio custom-control-block">
										<div class="form-group">
											<input type="radio" id="comment2" value="objective" name="comment" class="custom-control-input">
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
												<option value="Objective Wise">Objective Wise</option>
												<option value="Full Work">Full Work</option>
											</select>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Price</label>
										<input id="price" type="number" name="price" class="form-control resume" placeholder="">
									</div>
								</div>
							</div>
							<hr>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2" id="objectives">
										<h4 class="text-muted">Objectives</h4>
										<div>
											<h5 class="text-muted mt-1">Objective</h5>
											<label class="text-muted">Description</label>
											<input type="text" name="obj_description[]" class="form-control resume" placeholder="" required>
											<ul class="list-inline mb-0">
												<li class="list-inline-item">
													<div class="input-group mt-2 mb-2">
														<div class="custom-file">
															<input type="file" name="obj_file[]" class="custom-file-input" required>
															<label class="custom-file-label rounded"><i class="mdi mdi-cloud-upload mr-1"></i> Upload Files</label>
														</div>
													</div>
												</li>
		
												<li class="list-inline-item">
													<h6 class="text-muted mb-0">Upload Images, Videos Or Documents.</h6>
												</li>
											</ul>
											<label class="text-muted">Price</label>
											<input type="text" name="obj_price[]" class="form-control resume" placeholder="Only if pricing type is objective based">
											<label class="text-muted">Duration</label>
											<input name="obj_duration[]" type="text" class="form-control resume" placeholder="Ex: 1 week" required>
										</div>
									</div>
									<button class="btn btn-info mb-3" type="button" onclick="addObjective()">Add more objectives</button>
								</div>
							</div>
							<hr>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2" id="responsibilities">
										<h4 class="text-muted">Responsibilities</h4>
										<div>
											<label class="text-muted mt-1">Responsibility</label>
											<input type="text" name="responsibilities[]" class="form-control resume" placeholder="" required>
										</div>
									</div>
									<button class="btn btn-info mb-3" type="button" onclick="addResponsibility()">Add more responsibilities</button>
								</div>
							</div>
							<hr>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2" id="questions">
										<h4 class="text-muted">Questions</h4>
										<div>
											<label class="text-muted mt-1">Question</label>
											<input type="text" name="questions[]" class="form-control resume" placeholder="" required>
										</div>
									</div>
									<button class="btn btn-info mb-3" type="button" onclick="addQuestion()">Add more questions</button>
								</div>
							</div>
							<hr>

							<div class="row">
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Last Date To Apply</label>
										<input type="date" name="last_apply" class="form-control resume" placeholder="">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Last Date To Complete</label>
										<input type="date" name="last_complete" required class="form-control resume" placeholder="">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-12">
									<div class="form-group app-label mt-2">
										<label class="text-muted">Number of candidates required</label>
										<input type="number" onblur="if(this.value<1){this.value=1} this.value=parseInt(this.value)" name="candidates" min="1" step="1" required class="form-control resume" placeholder="">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-lg-12 mt-2">
									<button class="btn btn-primary">Post Work</button>
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
<script>
	function checkPricing(){
		const prices = $("input[name^=obj_price]");
		prices.map((key,price)=>{
			if($("#pricing").val()==="Full Work"){
				$(price).val(null);
				$(price).attr("readonly",true);
			}
			else{
				$(price).attr("readonly",false);
			}
		})
	}
	function addObjective(){
		const objective = `
			<div class="mt-3">
				<div class="row justify-content-around mt-1">
					<h5 class="text-muted col-md-6">Objective</h5>
					<div class="col-md-6">
						<button class="btn btn-danger btn-sm" type="button" onclick="deleteObjective(this)"><i class="fa fa-trash"></i></button>
					</div>
				</div>
				<label class="text-muted">Description</label>
				<input type="text" name="obj_description[]" class="form-control resume" placeholder="" required>
				<ul class="list-inline mb-0">
					<li class="list-inline-item">
						<div class="input-group mt-2 mb-2">
							<div class="custom-file">
								<input type="file" name="obj_file[]" class="custom-file-input" required>
								<label class="custom-file-label rounded"><i class="mdi mdi-cloud-upload mr-1"></i> Upload Files</label>
							</div>
						</div>
					</li>

					<li class="list-inline-item">
						<h6 class="text-muted mb-0">Upload Images, Videos Or Documents.</h6>
					</li>
				</ul>
				<label class="text-muted">Price</label>
				<input type="text" name="obj_price[]" class="form-control resume" placeholder="Only if pricing type is objective based">
				<label class="text-muted">Duration</label>
				<input name="obj_duration[]" type="text" class="form-control resume" placeholder="Ex: 1 week" required>
			</div>
		`;
		$("#objectives").append(objective);
		checkPricing();
	}
	function deleteObjective(obj){
		$($($($(obj).parent()).parent()).parent()).remove();
	}
	function addResponsibility(){
		const objective = `
			<div>
				<div class="row justify-content-around mt-1">
					<label class="text-muted col-md-6">Responsibility</label>
					<div class="col-md-6">
						<button class="btn btn-danger btn-sm" type="button" onclick="deleteResponsibility(this)"><i class="fa fa-trash"></i></button>
					</div>
				</div>
				<input type="text" name="responsibilities[]" class="form-control resume" placeholder="" required>
			</div>
		`;
		$("#responsibilities").append(objective);
	}
	function deleteResponsibility(obj){
		$($($($(obj).parent()).parent()).parent()).remove();
	}
	function addQuestion(){
		const objective = `
			<div>
				<div class="row justify-content-around mt-1">
					<label class="text-muted col-md-6">Question</label>
					<div class="col-md-6">
						<button class="btn btn-danger btn-sm" type="button" onclick="deleteQuestion(this)"><i class="fa fa-trash"></i></button>
					</div>
				</div>
				<input type="text" name="questions[]" class="form-control resume" placeholder="" required>
			</div>
		`;
		$("#questions").append(objective);
	}
	function deleteQuestion(obj){
		$($($($(obj).parent()).parent()).parent()).remove();
	}
</script>
@endsection