FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
#COPY *.sln .
COPY TodoApi/*.csproj ./TodoApi/

RUN dotnet restore

# Copy everything else and build app
#COPY TodoApi/. ./TodoApi/
COPY . ./

WORKDIR /app/TodoApi
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS runtime
WORKDIR /app
COPY --from=build /app/TodoApi/out ./
ENTRYPOINT ["dotnet", "TodoApi.dll"]