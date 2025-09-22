+++
date = "2016-02-15 16:47:57"
title = "Debugging golang programs"
draft = "false"
categories = ["technical"]
tags = ["FOSDEM", "control+backslash", "coredump", "debugging", "delve", "devops", "fedora", "gdb", "gluster", "golang", "mgmtconfig", "planetdevops", "planetfedora", "planetpuppet", "printf", "race"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/02/15/debugging-golang-programs/"
+++

I've been writing a lot of <a href="/blog/2016/01/18/next-generation-configuration-mgmt/">golang</a> lately. <a href="/blog/2015/07/27/golang-parallelism-issues-causing-too-many-open-files-error/">I've hit painful problems in the past.</a> Here are some debugging tips. Hopefully they help you out. I bet you don't know #2.

<strong><span style="text-decoration:underline;">#0 Use log.Printf</span>:</strong>

This should go without saying, but I'm ashamed to say it's what I use the most. We've only been <a href="https://en.wikipedia.org/wiki/C_%28programming_language%29">C programming</a> for 44+ years, and it's still what is most useful!

<strong><span style="text-decoration:underline;">#1 Use go run -race</span>:</strong>

Since many problems are caused by random races, ensuring you use the built-in tools will help you catch some problems. One of these is a race detector. You can use it by adding the <code>-race</code> flag to the <code>go run</code>, <code>go build</code> or <code>go test</code> commands. In practice, it only ever caught beginner issues, and it hasn't set off any alarms since. Maybe I need to write more test cases! Maybe <a href="https://github.com/purpleidea/mgmt/compare?expand=1"><strong><em>you</em></strong> need to write more test cases!</a>

<strong><span style="text-decoration:underline;">#2 Use Control+Backslash</span>:</strong>

Say what? If you press control+backslash, you will cause a core dump. Example:
```
james@computer:/tmp$ sleep 42h
^\Quit (core dumped)
```
Obviously there are nicer ways to kill a process (I for one, welcome our robotic overlords) but in times of emergency, use what you've got. The interesting thing, is that when you do this to a golang program, you'll get much more interesting output:
```
james@computer:~/code/mgmt$ ./mgmt run --file examples/graph0.yaml 
16:19:26 main.go:65: This is: mgmt, version: 0.0.2-6-g6e68d6d
16:19:26 main.go:66: Main: Start: 1455571166809588335
16:19:26 main.go:196: Main: Running...
16:19:26 main.go:106: Etcd: Starting...
16:19:26 etcd.go:132: Etcd: Watching...
16:19:26 configwatch.go:54: Watching: examples/graph0.yaml
16:19:26 etcd.go:159: Etcd: Waiting 1000 ms for connection...
16:19:26 main.go:149: Graph: Vertices(2), Edges(1)
16:19:26 main.go:152: Graphviz: No filename given!
16:19:26 main.go:163: State: graphNil -> graphStarting
16:19:26 main.go:165: State: graphStarting -> graphStarted
16:19:26 file.go:340: File[file1]: Apply
^\SIGQUIT: quit
PC=0x482a53 m=2

goroutine 0 [idle]:
runtime.futex(0xecae00, 0x0, 0x7f6f5dd8fde8, 0x0, 0x0, 0x4828ac, 0x3c, 0x0, 0x43392b, 0xecae00, ...)
    /usr/lib/golang/src/runtime/sys_linux_amd64.s:289 +0x23
runtime.futexsleep(0xecae00, 0x0, 0xdf8475800)
    /usr/lib/golang/src/runtime/os1_linux.go:56 +0xf0
runtime.notetsleep_internal(0xecae00, 0xdf8475800, 0xc820000900)
    /usr/lib/golang/src/runtime/lock_futex.go:171 +0x12b
runtime.notetsleep(0xecae00, 0xdf8475800, 0x0)
    /usr/lib/golang/src/runtime/lock_futex.go:191 +0x6b
runtime.sysmon()
    /usr/lib/golang/src/runtime/proc1.go:3022 +0x4aa
runtime.mstart1()
    /usr/lib/golang/src/runtime/proc1.go:715 +0xe8
runtime.mstart()
    /usr/lib/golang/src/runtime/proc1.go:685 +0x72

goroutine 1 [select]:
main.waitForSignal(0xc820076300)
    /home/james/code/mgmt/main.go:48 +0x5da
main.run(0xc82011c0f0)
    /home/james/code/mgmt/main.go:198 +0x779
github.com/codegangsta/cli.Command.Run(0xb4e9d8, 0x3, 0x0, 0x0, 0xc8200799d0, 0x1, 0x1, 0xb4e9d8, 0x3, 0x0, ...)
    /home/james/code/src/gopath/src/github.com/codegangsta/cli/command.go:127 +0x1052
github.com/codegangsta/cli.(*App).Run(0xc8200a8500, 0xc820074100, 0x4, 0x4, 0x0, 0x0)
    /home/james/code/src/gopath/src/github.com/codegangsta/cli/app.go:159 +0xc2f
main.main()
    /home/james/code/mgmt/main.go:283 +0xced

goroutine 17 [syscall, locked to thread]:
runtime.goexit()
    /usr/lib/golang/src/runtime/asm_amd64.s:1721 +0x1

goroutine 21 [syscall]:
os/signal.loop()
    /usr/lib/golang/src/os/signal/signal_unix.go:22 +0x18
created by os/signal.init.1
    /usr/lib/golang/src/os/signal/signal_unix.go:28 +0x37

goroutine 22 [select]:
main.run.func2(0xc82011c0f0, 0xc820122040, 0xc82011a5d0, 0xc82011e130, 0x5, 0xc820076360, 0xc82011e010)
    /home/james/code/mgmt/main.go:110 +0x1061
created by main.run
    /home/james/code/mgmt/main.go:168 +0x60c

goroutine 23 [select, locked to thread]:
runtime.gopark(0xc8a258, 0xc82002e728, 0xb4ec08, 0x6, 0x18, 0x2)
    /usr/lib/golang/src/runtime/proc.go:185 +0x163
runtime.selectgoImpl(0xc82002e728, 0x0, 0x18)
    /usr/lib/golang/src/runtime/select.go:392 +0xa64
runtime.selectgo(0xc82002e728)
    /usr/lib/golang/src/runtime/select.go:212 +0x12
runtime.ensureSigM.func1()
    /usr/lib/golang/src/runtime/signal1_unix.go:227 +0x353
runtime.goexit()
    /usr/lib/golang/src/runtime/asm_amd64.s:1721 +0x1

goroutine 7 [select]:
main.(*FileType).Watch(0xc820174180)
    /home/james/code/mgmt/file.go:156 +0x15f4
main.(*Graph).Start.func1(0xc82011e010, 0xc820010b80)
    /home/james/code/mgmt/pgraph.go:558 +0x7e
created by main.(*Graph).Start
    /home/james/code/mgmt/pgraph.go:560 +0x171

goroutine 25 [select]:
main.ConfigWatch.func1(0xc82009db40, 0x14, 0xc820076660)
    /home/james/code/mgmt/configwatch.go:74 +0x13c8
created by main.ConfigWatch
    /home/james/code/mgmt/configwatch.go:153 +0x67

goroutine 26 [sleep]:
time.Sleep(0x3b9aca00)
    /usr/lib/golang/src/runtime/time.go:59 +0xf9
main.(*EtcdWObject).EtcdWatch.func1(0x7f6f5c512c20, 0xc82009db80, 0xc820122040, 0xffffffffffffffff, 0xc820076360, 0xc820072af0)
    /home/james/code/mgmt/etcd.go:160 +0x7db
created by main.(*EtcdWObject).EtcdWatch
    /home/james/code/mgmt/etcd.go:205 +0xc2

goroutine 27 [chan send]:
main.(*EtcdWObject).EtcdChannelWatch.func1(0x7f6f5c512c78, 0xc820122140, 0x7f6f5c512ca0, 0xc8200786d0, 0xc8200766c0)
    /home/james/code/mgmt/etcd.go:109 +0xd9
created by main.(*EtcdWObject).EtcdChannelWatch
    /home/james/code/mgmt/etcd.go:111 +0x7b

goroutine 34 [syscall]:
syscall.Syscall6(0xe8, 0x4, 0xc82018dc24, 0x7, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0)
    /usr/lib/golang/src/syscall/asm_linux_amd64.s:44 +0x5
syscall.EpollWait(0x4, 0xc82018dc24, 0x7, 0x7, 0xffffffffffffffff, 0x0, 0x0, 0x0)
    /usr/lib/golang/src/syscall/zsyscall_linux_amd64.go:365 +0x89
gopkg.in/fsnotify%2ev1.(*fdPoller).wait(0xc820146000, 0xc89a00, 0x0, 0x0)
    /home/james/code/src/gopath/src/gopkg.in/fsnotify.v1/inotify_poller.go:85 +0xbc
gopkg.in/fsnotify%2ev1.(*Watcher).readEvents(0xc820158000)
    /home/james/code/src/gopath/src/gopkg.in/fsnotify.v1/inotify.go:179 +0x1af
created by gopkg.in/fsnotify%2ev1.NewWatcher
    /home/james/code/src/gopath/src/gopkg.in/fsnotify.v1/inotify.go:58 +0x315

goroutine 8 [select]:
main.(*NoopType).Watch(0xc82001c230)
    /home/james/code/mgmt/types.go:362 +0x31a
main.(*Graph).Start.func1(0xc82011e010, 0xc820010b60)
    /home/james/code/mgmt/pgraph.go:558 +0x7e
created by main.(*Graph).Start
    /home/james/code/mgmt/pgraph.go:560 +0x171

goroutine 31 [syscall]:
syscall.Syscall6(0xe8, 0x9, 0xc8201f7c24, 0x7, 0xffffffffffffffff, 0x0, 0x0, 0xc82017c440, 0xc82017c420, 0x15)
    /usr/lib/golang/src/syscall/asm_linux_amd64.s:44 +0x5
syscall.EpollWait(0x9, 0xc8201f7c24, 0x7, 0x7, 0xffffffffffffffff, 0x1, 0x0, 0x0)
    /usr/lib/golang/src/syscall/zsyscall_linux_amd64.go:365 +0x89
gopkg.in/fsnotify%2ev1.(*fdPoller).wait(0xc82009dcc0, 0x8000, 0x0, 0x0)
    /home/james/code/src/gopath/src/gopkg.in/fsnotify.v1/inotify_poller.go:85 +0xbc
gopkg.in/fsnotify%2ev1.(*Watcher).readEvents(0xc820090cd0)
    /home/james/code/src/gopath/src/gopkg.in/fsnotify.v1/inotify.go:179 +0x1af
created by gopkg.in/fsnotify%2ev1.NewWatcher
    /home/james/code/src/gopath/src/gopkg.in/fsnotify.v1/inotify.go:58 +0x315

rax    0xfffffffffffffffc
rbx    0x7f6f5dd8fde8
rcx    0x482a53
rdx    0x0
rdi    0xecae00
rsi    0x0
rbp    0x0
rsp    0x7f6f5dd8fdb0
r8     0x0
r9     0x0
r10    0x7f6f5dd8fde8
r11    0x246
r12    0x7ffec7010a4f
r13    0x7f6f5dd90700
r14    0x800000
r15    0x0
rip    0x482a53
rflags 0x246
cs     0x33
fs     0x0
gs     0x0
```
I find this particularly useful when you have a "stuck" goroutine. Killing the program usually makes it easy to find where everyone was waiting. AFAIK, everything is ordered by most recently used at the top. You're welcome!

<strong><span style="text-decoration:underline;">#3 Use a real debugger</span>:</strong>

There is a GDB like golang debugger called "<a href="https://github.com/derekparker/delve">delve</a>". It's probably something I would use more often, except I haven't needed that much power, and it still has a number of rough edges. I'm sure if you could help improve that, it would help out the project. There was a <a href="https://fosdem.org/2016/schedule/event/delve/">talk at FOSDEM</a> about it. If we're lucky, <a href="https://video.fosdem.org/2016/h1302/">we'll eventually get video</a>. I'm "looking forward" to using it more in the future.

Hope this helped,

Happy Hacking!

James

PS: The "other" slash, <strong>isn't</strong> called "forward slash", it's just called "slash"

PPS: Yes, I say "golang", no "go". I think it's shitty that <a href="https://en.wikipedia.org/wiki/Go!_%28programming_language%29#Conflict_with_Google">google basically ripped off the go! name</a>. I guess <a href="https://github.com/golang/go/issues/9">David lost this one</a>.

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
