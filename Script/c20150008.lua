--Planet Gradius
function c20150008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c20150008.tg)
	e2:SetValue(1200)
	c:RegisterEffect(e2)
	--Def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c20150008.tg)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--extra summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetDescription(aux.Stringid(20150008,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c20150008.extg)
	e5:SetOperation(c20150008.exop)
	c:RegisterEffect(e5)
	--change atk and def
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20150008,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(2)
	e4:SetTarget(c20150008.sptg)
	e4:SetOperation(c20150008.spop)
	c:RegisterEffect(e4)
end

function c20150008.tg(e,c)
	return c:GetLevel()==4 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:GetBaseAttack()<=1200
end

function c20150008.exfilter(c)
	return c:GetLevel()==4 and c:IsSummonable(true,nil)
		and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end

function c20150008.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20150008.exfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end

function c20150008.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c20150008.exfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		Duel.ConfirmCards(1-tp,tc)
	end
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end

function c20150008.estg(e,c)
	return c:GetLevel()==4 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end

function c20150008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and rp~=tp
	end
	Duel.SetTargetCard(eg)
end
function c20150008.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(1200)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e11=Effect.CreateEffect(e:GetHandler())
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_SET_BASE_DEFENSE)
			e11:SetValue(800)
			e11:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e11)
		end
		tc=g:GetNext()
	end
end