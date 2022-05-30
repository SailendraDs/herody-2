@extends('layouts.app')
@section("title",config("app.name").' | '.$page->heading)
@section('content')
<!-- JOB LIST START -->
<section class="section pt-0">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12">
				<div class="section-title text-center mb-4 pb-2">
					<h4 class="title title-line pb-5">{{$page->heading}}</h4>
				</div>
			</div>
		</div>
		<div class="container">
			<div class="home-form-position">
				<div class="row justify-content-center">
					<div class="col-lg-10">
						<div class="home-registration-form job-list-reg-form bg-light shadow p-4 mb-3">
                            {!!$page->description!!}
						</div>
					</div>
				</div>
			</div>
		</div>
		

		<div class="row">
			<div class="col-lg-12">
                <h5 class="text-center">Fill the form</h5>
                <form action="{{route("join-team")}}" method="post" enctype="multipart/form-data">
                    @csrf
                    <div class="row d-flex justify-content-center">
                        <div class="col-md-10">
                            <div class="form-group">
                                <input type="text" class="form-control" name="name" placeholder="Name">
                            </div>
                        </div>
                        <div class="col-md-10">
                            <div class="form-group">
                                <input type="email" class="form-control" name="email" placeholder="Email">
                            </div>
                        </div>
                        <div class="col-md-10">
                            <div class="form-group">
                                <input type="tel" class="form-control" name="phone" placeholder="Phone Number">
                            </div>
                        </div>
                        <div class="col-md-10">
                            <div class="form-group">
                                <input type="text" class="form-control" name="linkedin" placeholder="Linkedin Profile URL">
                            </div>
                        </div>
                        <div class="col-md-10">
                            <div class="form-group">
                                <ul class="list-inline mb-0">
                                    <li class="list-inline-item">
                                        <div class="input-group mt-2 mb-2">
                                            <div class="custom-file">
                                                <input type="file" name="resume" accept=".pdf" class="custom-file-input" required>
                                                <label class="custom-file-label rounded"><i class="mdi mdi-cloud-upload mr-1"></i> Resume</label>
                                            </div>
                                        </div>
                                    </li>

                                    <li class="list-inline-item">
                                        <h6 class="text-muted mb-0">Upload PDF</h6>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-md-10">
                            <div class="form-group">
                                <select name="category" id="category" class="custom-select">
                                    <option value="">Select a category</option>
                                    @if($categories->count()===0)
                                    <option value="">No category found. Please contact administrator</option>
                                    @else
                                        @foreach ($categories as $category)
                                            <option value="{{$category->id}}">{{$category->category}}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                        <div class="col-md-10">
                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea name="description" id="description" placeholder="Your Description"></textarea>
                            </div>
                        </div>
                        <div class="col-md-10">
                            <button class="btn btn-primary">Send</button>
                        </div>
                    </div>
                </form>
			</div>
		</div>
	</div>
</section>
<!-- JOB LIST START -->
@endsection
@section('scripts')
<script src="https://cdn.ckeditor.com/4.13.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('description');
</script>
@endsection