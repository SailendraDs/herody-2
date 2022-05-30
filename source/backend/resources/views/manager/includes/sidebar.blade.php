<div class="sidebar sidebar-dark bg-dark">
    <ul class="list-unstyled">
        <li class="active"><a href="{{route('manager.dashboard')}}"><i class="fa fa-home"></i> Dashboard</a></li>

        <li>
            <a href="#Jobs" data-toggle="collapse">
                <i class="fas fa-briefcase"></i> Works
            </a>
            <ul id="Jobs" class="list-unstyled collapse">

                <li><a href="{{route('manager.work.pending')}}"><i class="far fa-circle"></i> Pending Works</a></li>
                <li><a href="{{route('manager.work.all')}}"><i class="far fa-circle"></i> All Works</a></li>
                <li><a href="{{route('manager.work.export')}}"><i class="far fa-circle"></i> Export all to excel</a></li>

            </ul>
        </li>
        <li id="employers"><a href="{{route('manager.employers')}}"><i class="fa fa-building"></i> Employers</a></li>
        <li id="chats"><a href="{{route('manager.chats')}}"><i class="fa fa-comments"></i> Chats</a></li>

        <li>
            <a href="#memberSetting" data-toggle="collapse">
                <i class="fa fa-fw fa-users"></i> Member Settings
            </a>
            <ul id="memberSetting" class="list-unstyled collapse">

                <li><a href="{{route('manager.member.all')}}"><i class="far fa-circle"></i> All Member</a></li>

            </ul>
        </li>

    </ul>

</div>

