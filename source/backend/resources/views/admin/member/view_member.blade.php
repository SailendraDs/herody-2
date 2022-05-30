@extends('admin.master')

@section('title', 'Admin | view member')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">View member</h2>

        <div class="card mb-4 content-main-div">
            <div class="card-body">
                <form action="{{route('admin.member.update')}}" method="post" enctype="multipart/form-data">
                    @csrf
                    <input type="hidden" name="id" value="{{$userById->id}}">
                    <div class="row">
                        <div class="col-md-3" style="box-shadow: 0 0 20px 5px rgba(0, 0, 0, 0.095); padding: 30px;">
                            <div class="col-md-12">
                                @if(is_null($userById->profile_photo))
                                    <img style="width: 150px;height: 150px;" class="img-thumbnail img-responsive"
                                         src="{{asset('assets/user/images/frontEnd/demo.png')}}">
                                @else

                                    <img style="width: 150px;height: 150px;" class="img-thumbnail img-responsive"
                                         src="{{asset('assets/user/images/user_profile/'.$userById->profile_photo)}}">

                                @endif
                                <input type="file" class="form-control mt-2" name="profile_photo">
                                <small class="text-info">( Image will be resized into 224 x 235 px
                                    )
                                </small>
                            </div>
                        </div>
                        <div class="col-md-9">
                            <div class="container"
                                 style="box-shadow: 0 0 20px 5px rgba(0, 0, 0, 0.095); padding: 30px;">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="name"
                                                   style="text-transform: uppercase;"><strong>Name</strong></label>
                                            <input class="form-control form-control-lg mb-3" name="name"
                                                   value="{{$userById->name}}" type="text">

                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="username" style="text-transform: uppercase;"><strong>Phone
                                                    No</strong></label>
                                            <input class="form-control form-control-lg mb-3" name="phone"
                                                   value="{{$userById->phone}}" type="text">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="mobile"
                                                   style="text-transform: uppercase;"><strong>State</strong></label>
                                            <input class="form-control form-control-lg mb-3" name="state"
                                                   value="{{$userById->state}}" type="text">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="email"
                                                   style="text-transform: uppercase;"><strong>Address</strong></label>
                                            <input class="form-control form-control-lg mb-3" name="address"
                                                   value="{{$userById->address}}" type="text">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="email"
                                                   style="text-transform: uppercase;"><strong>Zip Code</strong></label>
                                            <input class="form-control form-control-lg mb-3" name="zip_code"
                                                   value="{{$userById->zip_code}}" type="text">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="email"
                                                   style="text-transform: uppercase;"><strong>Email</strong></label>
                                            <input class="form-control form-control-lg mb-3" name="email"
                                                   value="{{$userById->email}}" type="text" disabled>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="email"
                                                   style="text-transform: uppercase;"><strong>User name</strong></label>
                                            <input class="form-control form-control-lg mb-3" name="user_name"
                                                   value="{{$userById->user_name}}" type="text" disabled>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-12 mt-4">
                        <button type="submit" class="btn btn-primary btn-block btn-lg text-uppercase customs-btn-bd">
                            Update
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>


    {{--dropdown active--}}
    <script>
        $('#memberSetting li:nth-child(1)').addClass('active');
        $('#memberSetting').addClass('show');
    </script>
@endsection
