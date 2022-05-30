@extends('admin.master')

@section('title', 'Admin | Join Team Page')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Join Team</h2>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Page
            </div>
            <div class="card-body">
                <form action="{{route("admin.custom-project.page")}}" method="post" enctype="multipart/form-data">
                    @csrf
                    <div class="form-group">
                        <label for="heading">Heading</label>
                        <input type="text" class="form-control" name="heading" value="{{$page->heading}}">
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea name="description" id="description">{{$page->description}}</textarea>
                    </div>
                    <div class="row">
                        <div class="col-lg-9 col-md-12 mt-2">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text" id="inputGroupFileAddon01">Upload image</span>
                                    </div>
                                    <div class="custom-file">
                                    <input type="file" name="image" accept=".jpeg,.png,.jpg" class="custom-file-input" id="inputGroupFile01" aria-describedby="inputGroupFileAddon01">
                                    <label class="custom-file-label" for="inputGroupFile01">Choose image</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-12 mt-2">
                            <img src="{{asset("assets/custom_project/image/".$page->image)}}" alt="image" height="200px" width="200px" class="img-fluid img-responsive">
                        </div>
                    </div>
                    <div class="form-group">
                        <button class="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    {{--dropdown active--}}
    <script>
        $('#customProject li:nth-child(1)').addClass('active');
        $('#customProject').addClass('show');
    </script>
@endsection
@section('scripts')
<script src="https://cdn.ckeditor.com/4.13.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('description');
</script>
@endsection