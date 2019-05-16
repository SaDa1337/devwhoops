#prep final container
FROM microsoft/dotnet:2.2-aspnetcore-runtime-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

#restore backend
FROM microsoft/dotnet:2.2-sdk-alpine AS build
WORKDIR /src
COPY ./DevWhoops/DevWhoops.csproj .
RUN dotnet restore DevWhoops.csproj --source https://api.nuget.org/v3/index.json 

#build backend
COPY ./DevWhoops .
RUN dotnet build "DevWhoops.csproj" -c Release --no-restore -o /app

#publish backend
FROM build AS publish
RUN dotnet publish "DevWhoops.csproj" -c Release --no-restore -o /app

#build frontend
FROM node:10.15-alpine as frontend
WORKDIR /usr/src/app

COPY ./DevWhoops/ClientApp/package.json .
COPY ./DevWhoops/ClientApp/package-lock.json .
COPY ./DevWhoops/ClientApp/tsconfig.json .
COPY ./DevWhoops/ClientApp/tslint.json .
COPY ./DevWhoops/ClientApp/angular.json .
RUN npm install

COPY ./DevWhoops/ClientApp/ .
RUN npm run-script build --prod
RUN ls

#wire up final container
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
RUN mkdir -p wwwroot
COPY --from=frontend /usr/src/app/dist ./wwwroot
ENTRYPOINT ["dotnet", "DevWhoops.dll"]
