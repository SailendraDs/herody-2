<?php
    if($emp->cname!=NULL){
        echo "<script>history.back();</script>"
;    }
?>
@extends('layouts.app')
@section('title',config('app.name').' | Edit Company Details')
@section('content')
<div class="container mt-4 mb-4">
    <div class="row">
        <div class="col-md-12">
            <h2 class="text-center">Edit Company Details</h2>
            <form action="{{route('employer.save.company')}}" method="POST" enctype="multipart/form-data">
            @csrf
                <div class="form-group mb-3">
                    <label for="cname">Company Name <small>Cannot be changed later</small></label>
                    <input type="text" class="form-control" name="cname" value="{{$emp->cname}}">
                </div>
                <div class="form-group mb-3">
                    <input type="file" name="profile_image" id="clg_inp" accept=".png,.jpg,.jpeg" onchange="getn(this.value)" hidden>
                    <button type="button" class="btn btn-warning" onclick="document.getElementById('clg_inp').click();">Upload Company Logo</button>
                    <div id="img"></div>
                </div>
                <div class="form-group mb-3">
                    <label for="description">Company Description</label>
                    <textarea id="description" name="description">{{$emp->description}}</textarea>
                </div>
                <div class="form-group mb-3">
                    <label for="website">Company Website</label>
                    <input type="text" class="form-control" name="website" value="{{$emp->website}}">
                </div>
                <button class="btn btn-primary">Submit</button>
            </form>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script src="https://cdn.ckeditor.com/4.13.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('description');
</script>
<script>
    function getn(str){
        str = str.split(/(\\|\/)/g).pop();
        $('#img').html(str);
    }
</script>
@endsection