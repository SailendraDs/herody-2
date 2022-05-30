<?php $countries = DB::table('countries')->orderBy('name','asc')->get(); ?>
@extends('layouts.authApp')
@section('title',config('app.name').' | ' .$employer->name)
@section("heads")
<style>
#btndp{
    margin: 2em 0 1em 2em;
    border: 1px solid green;
    color: black;
    background: white;
    border-radius: 5px;
    font-size: 1.25em;
    font-weight: bold;
    cursor: pointer;
}
#btndp:hover{
    background: green;
    color: white;
    border-color: black;
}
</style>
@endsection
@section('content')
<div class="container ml-4">
<div class="row">
<div class="col-lg-12">
  <div class="my_profile_form_area">
    <div class="row">
      <div class="col-lg-12 page-head">
        <h4 class="fz20 mb20">Company Profile</h4>
      </div>
      <div class="col-lg-6">
        <form id="profile_image" method="POST" enctype="multipart/form-data" action="{{route('employer.profile_image.update')}}">
            @csrf
            <input class="btn btn-thm" id="imageUpload" accept=".png,.jpg,.bpm,.jpeg,.gif" type="file" onchange="document.getElementById('profile_image').submit();" name="profile_image" />
        </form>
      </div>
      <div class="col-lg-6">
        <img height="100px" width="100px" src="@if($employer->profile_photo==NULL) {{asset('assets/user/images/frontEnd/demo.png')}} @else {{asset('assets/employer/profile_images/'.$employer->profile_photo)}} @endif" class="img-responsive rounded-circle">
      </div>
      <div class="col-lg-12">
        <div class="my_profile_thumb_edit"></div>
                    </div>
                    
              <form method="POST" action="{{route('employer.profile')}}" class="pr-2">
                @csrf
              <h6 class="heading-small text-muted mb-4">Personal information</h6>
              <div class="pl-lg-4">
                <div class="row">
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="cname">Company Name</span>
                      <input type="text" name="cname" class="form-control" placeholder="Company Name" value="{{$employer->cname}}">
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="email">Email address</span>
                      <input type="email" name="email" class="form-control" placeholder="Email" value="{{$employer->email}}">
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="name">Name</span>
                      <input type="text" name="name" class="form-control" placeholder="Name" value="{{$employer->name}}">
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="phone">Phone</span>
                      <input type="text" name="phone" class="form-control" placeholder="Phone" value="{{$employer->phone}}">
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="website">Website</span>
                      <input type="text" name="website" class="form-control" placeholder="Website" value="{{$employer->website}}">
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="category">Category</span>
                      <input type="text" name="category" class="form-control" placeholder="Category" value="{{$employer->category}}">
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="cin">Company CIN</span>
                      <input type="text" placeholder="CIN" name="cin" class="form-control" value="{{$employer->cin}}">
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="gstin">GSTIN</span>
                      <input type="text" name="gstin" class="form-control" placeholder="GSTIN" value="{{$employer->gstin}}">
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="founded">PAN</span>
                      <input type="text" name="pan" class="form-control" placeholder="PAN" value="{{$employer->pan}}">
                    </div>
                  </div>
                </div>
              </div>
              <hr class="my-4" />
              <!-- Address -->
              <h6 class="heading-small text-muted mb-4">Contact information</h6>
              <div class="pl-lg-4">
                <div class="row">
                  <div class="col-md-12">
                    <div class="form-group">
                      <span class="form-control-label" for="address">Address</span>
                      <input name="address" class="form-control" placeholder="Address" value="{{$employer->address}}" type="text">
                    </div>
                  </div>
                  <div class="col-lg-6">
                      <div class="form-group">
                        <span class="form-control-label" for="country">Country</span>
                        <select name="country" id="countries" class="custom-select">
                            @foreach($countries as $country)
                            <option value="{{$country->name}}" @if($country->name==$employer->country) selected @endif>{{$country->name}}</option>
                            @endforeach
                        </select>
                      </div>
                  </div>
                  <div class="col-lg-6">
                      <div class="form-group">
                        <span class="form-control-label" for="state">State</span>
                        <select name="state" id="states" class="custom-select">
                            <option value="{{$employer->state}}">{{$employer->state}}</option>
                        </select>
                      </div>
                  </div>
              </div>
                <div class="row">
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="city">City</span>
                      <select name="city" id="cities" class="custom-select">
                          <option value="{{$employer->city}}">{{$employer->city}}</option>
                      </select>
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <span class="form-control-label" for="zip_code">Postal code</span>
                      <input type="text" name="zip_code" class="form-control" placeholder="Postal code" value="{{$employer->zip_code}}">
                    </div>
                  </div>
                </div>
              </div>
              <hr class="my-4" />
              <!-- Description -->
              <h6 class="heading-small text-muted mb-4">About</h6>
              <div class="pl-lg-4">
                <div class="form-group">
                  <span class="form-control-label">About Company</span>
                  <textarea id="description" name="description">{{$employer->description}}</textarea>
                </div>
              </div>
              <hr class="my-4">
              <h6 class="heading-small text-muted mb-4">Social Networks</h6>
              <div class="pl-lg-4">
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group">
                      <span class="form-control-label" for="facebook">Facebook</span>
                      <input name="facebook" class="form-control" placeholder="Facebook" value="{{$employer->facebook}}" type="text">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <span class="form-control-label" for="twitter">Twitter</span>
                      <input name="twitter" class="form-control" placeholder="Twitter" value="{{$employer->twitter}}" type="text">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <span class="form-control-label" for="gplus">G-Plus</span>
                      <input name="gplus" class="form-control" placeholder="G-Plus" value="{{$employer->gplus}}" type="text">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <span class="form-control-label" for="youtube">Youtube</span>
                      <input name="youtube" class="form-control" placeholder="Youtube" value="{{$employer->youtube}}" type="text">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <span class="form-control-label" for="vimeo">Vimeo</span>
                      <input name="vimeo" class="form-control" placeholder="Vimeo" value="{{$employer->vimeo}}" type="text">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <span class="form-control-label" for="linkedin">LinkedIn</span>
                      <input name="linkedin" class="form-control" placeholder="LinkedIn" value="{{$employer->linkedin}}" type="text">
                    </div>
                  </div>
                </div>
              </div>
              <button type="submit" class="btn btn-success">Save Setting</button>
            </form>
  </div>
</div>
</div>
@endsection

@section('scripts')
<script src="{{asset('assets/main/js/world.js')}}"></script>
<script src="https://cdn.ckeditor.com/4.13.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('description');
</script>
@endsection