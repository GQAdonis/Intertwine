create type "MemberRole" as enum ('ADMIN', 'MODERATOR', 'GUEST');

alter type "MemberRole" owner to postgres;

create type "ChannelType" as enum ('TEXT', 'AUDIO', 'VIDEO');

alter type "ChannelType" owner to postgres;

create table if not exists "Profile"
(
    id          text                                   not null
    primary key,
    "userId"    text                                   not null,
    name        text                                   not null,
    "imageUrl"  text                                   not null,
    email       text                                   not null,
    "createdAt" timestamp(3) default CURRENT_TIMESTAMP not null,
    "updatedAt" timestamp(3)                           not null
    );

alter table "Profile"
    owner to postgres;

create unique index if not exists "Profile_userId_key"
    on "Profile" ("userId");

create table if not exists "Server"
(
    id           text                                   not null
    primary key,
    name         text                                   not null,
    "imageUrl"   text                                   not null,
    "inviteCode" text                                   not null,
    "profileId"  text                                   not null,
    "createdAt"  timestamp(3) default CURRENT_TIMESTAMP not null,
    "updatedAt"  timestamp(3)                           not null
    );

alter table "Server"
    owner to postgres;

create unique index if not exists "Server_inviteCode_key"
    on "Server" ("inviteCode");

create index if not exists "Server_profileId_idx"
    on "Server" ("profileId");

create table if not exists "Member"
(
    id          text                                                             not null
    primary key,
    role        intertwine."MemberRole" default 'GUEST'::intertwine."MemberRole" not null,
    "profileId" text                                                             not null,
    "serverId"  text                                                             not null,
    "createdAt" timestamp(3)            default CURRENT_TIMESTAMP                not null,
    "updatedAt" timestamp(3)                                                     not null
    );

alter table "Member"
    owner to postgres;

create index if not exists "Member_profileId_idx"
    on "Member" ("profileId");

create index if not exists "Member_serverId_idx"
    on "Member" ("serverId");

create table if not exists "Channel"
(
    id          text                                                              not null
    primary key,
    name        text                                                              not null,
    type        intertwine."ChannelType" default 'TEXT'::intertwine."ChannelType" not null,
    "profileId" text                                                              not null,
    "serverId"  text                                                              not null,
    "createdAt" timestamp(3)             default CURRENT_TIMESTAMP                not null,
    "updatedAt" timestamp(3)                                                      not null
    );

alter table "Channel"
    owner to postgres;

create index if not exists "Channel_profileId_idx"
    on "Channel" ("profileId");

create index if not exists "Channel_serverId_idx"
    on "Channel" ("serverId");

create table if not exists "Message"
(
    id          text                                   not null
    primary key,
    content     text                                   not null,
    "fileUrl"   text,
    "memberId"  text                                   not null,
    "channelId" text                                   not null,
    deleted     boolean      default false             not null,
    "createdAt" timestamp(3) default CURRENT_TIMESTAMP not null,
    "updatedAt" timestamp(3)                           not null
    );

alter table "Message"
    owner to postgres;

create index if not exists "Message_channelId_idx"
    on "Message" ("channelId");

create index if not exists "Message_memberId_idx"
    on "Message" ("memberId");

create table if not exists "Conversation"
(
    id            text not null
    primary key,
    "memberOneId" text not null,
    "memberTwoId" text not null
);

alter table "Conversation"
    owner to postgres;

create index if not exists "Conversation_memberTwoId_idx"
    on "Conversation" ("memberTwoId");

create unique index if not exists "Conversation_memberOneId_memberTwoId_key"
    on "Conversation" ("memberOneId", "memberTwoId");

create table if not exists "DirectMessage"
(
    id               text                                   not null
    primary key,
    content          text                                   not null,
    "fileUrl"        text,
    "memberId"       text                                   not null,
    "conversationId" text                                   not null,
    deleted          boolean      default false             not null,
    "createdAt"      timestamp(3) default CURRENT_TIMESTAMP not null,
    "updatedAt"      timestamp(3)                           not null
    );

alter table "DirectMessage"
    owner to postgres;

create index if not exists "DirectMessage_memberId_idx"
    on "DirectMessage" ("memberId");

create index if not exists "DirectMessage_conversationId_idx"
    on "DirectMessage" ("conversationId");

