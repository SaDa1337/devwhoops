FROM microsoft/dotnet:2.2-sdk as build
WORKDIR /src
COPY ./DevWhoops .
RUN dotnet build "DevWhoops.csproj" -c Release  -o /app
RUN dotnet publish "DevWhoops.csproj" -c Release --no-restore -o /app

WORKDIR /src/ClientApp
RUN apt-get update -yq && apt-get upgrade -yq && apt-get install -yq curl git nano
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -yq nodejs build-essential
RUN npm install
RUN npm run-script build --prod

WORKDIR /app
RUN mkdir -p wwwroot
RUN cp -R /src/ClientApp/dist/* ./wwwroot

ENTRYPOINT ["dotnet", "DevWhoops.dll"]
