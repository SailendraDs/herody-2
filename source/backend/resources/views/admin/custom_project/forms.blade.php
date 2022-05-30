@extends('admin.master')

@section('title', 'Admin | Custom Project Forms')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Custom Project</h2>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Forms
            </div>
            <div class="card-body">
                @if(count($forms)==0)
                    <h2 class="text-center">@lang('No Data Available')</h2>
                @else
                    <table class="table  table-striped table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Name</th>
                            <th scope="col">Email</th>
                            <th scope="col">Phone Number</th>
                            <th scope="col">Startup Name</th>
                            <th scope="col">Resume</th>
                            <th scope="col">Facebook</th>
                            <th scope="col">Instagram</th>
                            <th scope="col">Linkedin</th>
                            <th scope="col">Category</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($forms as $form)
                            <tr>
                                <th scope="row">{{$loop->iteration}}</th>
                                <th scope="row">{{$form->name}}</th>
                                <th scope="row">{{$form->email}}</th>
                                <th scope="row">{{$form->phone}}</th>
                                <th scope="row">{{$form->startup??"NA"}}</th>
                                <th scope="row"><a href="{{asset("assets/custom_project/resume/".$form->resume)}}" class="btn btn-link">Click to view resume</a></th>
                                <th scope="row">{{$form->facebook}}</th>
                                <th scope="row">{{$form->instagram}}</th>
                                <th scope="row">{{$form->linkedin}}</th>
                                <th scope="row">{{$form->category->category}}</th>
                                <th scope="row">
                                    <form action="{{route('admin.custom-project.forms.delete')}}" method="post">
                                    @csrf
                                        <input type="hidden" name="id" value="{{$form->id}}">
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                </th>
                                
                            </tr>
                        @endforeach

                        </tbody>
                    </table>
                @endif
                {{$forms->links()}}
            </div>
        </div>
    </div>
    {{--dropdown active--}}
    <script>
        $('#customProject li:nth-child(3)').addClass('active');
        $('#customProject').addClass('show');
    </script>
@endsection