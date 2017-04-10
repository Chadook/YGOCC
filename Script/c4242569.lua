--MoonBurst:The Awakened

function c4242569.initial_effect(c)
c:SetUniqueOnField(1,0,4242569)
			--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c4242569.spcon)
	e1:SetOperation(c4242569.spop)
	c:RegisterEffect(e1)
			--summon success
	--local e2=Effect.CreateEffect(c)
--	e2:SetType(EFFECT_TYPE_SINGLE)
--	e2:SetCode(EFFECT_MATERIAL_CHECK)
--	e2:SetValue(c4242569.matcheck)
--	c:RegisterEffect(e2)
	--Pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
--(	--cannot negate summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--Nuke field, cannot negate
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c4242569.target)
	e5:SetOperation(c4242569.operation)
	c:RegisterEffect(e5)
end
	
	--Sp summon rule
function c4242569.spfilter(c)
	return c:IsFusionSetCard(0x666) and c:IsCanBeFusionMaterial() and c:IsFaceup()
end

function c4242569.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c4242569.spfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=5
end
function c4242569.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c4242569.spfilter,tp,LOCATION_EXTRA,0,nil)
	local rg=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
	
	
function c4242569.matcheck(e,c)
	local ct=c:GetMaterial()
	if ct:GetCount()==1 then
	--Nuke on summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242569,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c4242569.target)
	e1:SetOperation(c4242569.operation)
	c:RegisterEffect(e1)
	end
	--Nuke on summon
	if ct:GetCount()==8 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242569,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c4242569.target)
	e1:SetOperation(c4242569.operation)
	c:RegisterEffect(e1)
	end
	--Can't negate nuke
	if ct:GetCount()==3 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c4242569.target)
	e1:SetOperation(c4242569.operation)
	c:RegisterEffect(e1)
	end
	end
--Nuke on summon
function c4242569.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c4242569.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
	
	
	
