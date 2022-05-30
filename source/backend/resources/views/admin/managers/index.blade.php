@extends('admin.master')

@section('title', 'Admin | All Managers')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Managers List</h2>
            <button class="btn btn-primary mb-2" data-toggle="modal" data-target="#create">Create Manager</button>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Managers
            </div>
            <div class="card-body">
                @if(count($managers)==0)
                    <h2 class="text-center">@lang('No Data Available')</h2>
                @else
                    <table class="table  table-striped table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Name</th>
                            <th scope="col">User Name</th>
                            <th scope="col">Team ID</th>
                            <th scope="col">Email</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($managers as $manager)
                            <tr>
                                <th scope="row">{{$loop->iteration}}</th>
                                <th scope="row">{{$manager->name}}</th>
                                <th scope="row">{{$manager->username}}</th>
                                <th scope="row">{{$manager->team_id}}</th>
                                <th scope="row">{{$manager->email}}</th>
                                <th scope="row">
                                    <form action="{{route('admin.manager.delete')}}" method="post">
                                    @csrf
                                        <input type="hidden" name="id" value="{{$manager->id}}">
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                </th>
                                
                            </tr>
                        @endforeach

                        </tbody>
                    </table>
                @endif
                {{$managers->links()}}
            </div>
        </div>
    </div>
    
    
    <div class="modal fade" id="create" tabindex="-1" role="dialog" aria-labelledby="create">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Create a new manager</h4>
                </div>
                <form action="{{route('admin.manager.create')}}" method="post">
                    @csrf
                    <div class="modal-body">
                        <div class="input-group mb-2">
                            <input type="text" placeholder="Enter Manager Name" name="name" class="form-control">
                        </div>
                        <div class="input-group mb-2">
                            <input type="email" placeholder="Enter Manager Email" name="email" class="form-control">
                        </div>
                        <div class="input-group mb-2">
                            <input type="text" placeholder="Enter Manager Username" name="username" class="form-control">
                        </div>
                        <div class="input-group mb-2">
                            <input type="password" placeholder="Enter Manager Password" name="password" class="form-control">
                        </div>
                        <div class="input-group mb-2">
                            <input type="text" placeholder="Enter Manager Phone" name="phone" class="form-control">
                        </div>
                        <div class="input-group mb-2">
                            <input type="text" placeholder="Enter Manager Team Id" name="team_id" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Create</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    {{--dropdown active--}}
    <script>
        $('#pending li:nth-child(2)').addClass('active');
        $('#pending').addClass('show');
    </script>
@endsection